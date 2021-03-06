//
//  RealmCache.swift
//  Kinvey
//
//  Created by Victor Barros on 2016-06-15.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

internal class RealmCache<T: Persistable>: Cache<T> where T: NSObject {
    
    let realm: Realm
    let objectSchema: ObjectSchema
    let propertyNames: [String]
    let executor: Executor
    
    lazy var entityType = T.self as! Entity.Type
    
    required init(persistenceId: String, fileURL: URL? = nil, encryptionKey: Data? = nil, schemaVersion: UInt64) {
        if !(T.self is Entity.Type) {
            let message = "\(T.self) needs to be a Entity"
            log.severe(message)
            fatalError(message)
        }
        var configuration = Realm.Configuration()
        if let fileURL = fileURL {
            configuration.fileURL = fileURL
        }
        configuration.encryptionKey = encryptionKey
        configuration.schemaVersion = schemaVersion
        
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            configuration.deleteRealmIfMigrationNeeded = true
            realm = try! Realm(configuration: configuration)
        }
        
        let className = NSStringFromClass(T.self).components(separatedBy: ".").last!
        objectSchema = realm.schema[className]!
        propertyNames = objectSchema.properties.map { return $0.name }
        executor = Executor()
        super.init(persistenceId: persistenceId)
        log.debug("Cache File: \(self.realm.configuration.fileURL!.path)")
    }
    
    fileprivate func results(_ query: Query) -> RealmSwift.Results<Entity> {
        log.verbose("Fetching by query: \(query)")
        var realmResults = self.realm.objects(self.entityType)
        if let predicate = query.predicate {
            realmResults = realmResults.filter(predicate)
        }
        if let sortDescriptors = query.sortDescriptors {
            for sortDescriptor in sortDescriptors {
                realmResults = realmResults.sorted(byProperty: sortDescriptor.key!, ascending: sortDescriptor.ascending)
            }
        }
        
        if let ttl = ttl, let kmdKey = T.metadataProperty() {
            realmResults = realmResults.filter("\(kmdKey).lrt >= %@", Date().addingTimeInterval(-ttl))
        }
        
        return realmResults
    }
    
    fileprivate func newInstance<P: Persistable>(_ type: P.Type) -> P {
        return type.init()
    }
    
    override func detach(_ entity: T) -> T {
        log.verbose("Detaching object: \(entity)")
        let json = entity.dictionaryWithValues(forKeys: propertyNames)
        let obj = newInstance(T.self)
        obj.setValuesForKeys(json)
        return obj
    }
    
    override func detach(_ results: [T], query: Query?) -> [T] {
        log.verbose("Detaching \(results.count) object(s)")
        var detachedResults = [T]()
        let skip = query?.skip ?? 0
        let limit = query?.limit ?? results.count
        var arrayEnumerate: [T]
        if skip != 0 || limit != results.count {
            let begin = max(min(skip, results.count), 0)
            let end = max(min(skip + limit, results.count), 0)
            arrayEnumerate = Array<T>(results[begin ..< end])
        } else {
            arrayEnumerate = results
        }
        for entity in arrayEnumerate {
            detachedResults.append(detach(entity))
        }
        return detachedResults
    }
    
    func detach(_ results: RealmSwift.Results<Entity>, query: Query?) -> [T] {
        return detach(results.map { $0 as! T }, query: query)
    }
    
    override func saveEntity(_ entity: T) {
        log.verbose("Saving object: \(entity)")
        executor.executeAndWait {
            try! self.realm.write {
                self.realm.create((type(of: entity) as! Entity.Type), value: entity, update: true)
            }
        }
    }
    
    override func saveEntities(_ entities: [T]) {
        log.verbose("Saving \(entities.count) object(s)")
        executor.executeAndWait {
            try! self.realm.write {
                for entity in entities {
                    self.realm.create((type(of: entity) as! Entity.Type), value: entity, update: true)
                }
            }
        }
    }
    
    override func findEntity(_ objectId: String) -> T? {
        log.verbose("Finding object by ID: \(objectId)")
        var result: T?
        executor.executeAndWait {
            result = self.realm.object(ofType: self.entityType, forPrimaryKey: objectId) as? T
            if result != nil {
                result = self.detach(result!)
            }
        }
        return result
    }
    
    override func findEntityByQuery(_ query: Query) -> [T] {
        log.verbose("Finding objects by query: \(query)")
        var results = [T]()
        executor.executeAndWait {
            results = self.detach(self.results(query), query: query)
        }
        return results
    }
    
    override func findIdsLmtsByQuery(_ query: Query) -> [String : String] {
        log.verbose("Finding ids and lmts by query: \(query)")
        var results = [String : String]()
        executor.executeAndWait {
            for entity in self.results(Query(predicate: query.predicate)) {
                if let entityId = entity.entityId, let lmt = entity.metadata?.lmt {
                    results[entityId] = lmt
                }
            }
        }
        return results
    }
    
    override func findAll() -> [T] {
        log.verbose("Finding All")
        var results = [T]()
        executor.executeAndWait {
            results = self.detach(self.realm.objects(self.entityType), query: nil)
        }
        return results
    }
    
    override func count(_ query: Query? = nil) -> Int {
        log.verbose("Counting by query: \(query)")
        var result = 0
        executor.executeAndWait {
            if let query = query {
                result = self.results(query).count
            } else {
                result = self.realm.objects(self.entityType).count
            }
        }
        return result
    }
    
    override func removeEntity(_ entity: T) -> Bool {
        log.verbose("Removing object: \(entity)")
        var result = false
        if let entityId = entity.entityId {
            executor.executeAndWait {
                var found = false
                try! self.realm.write {
                    if let entity = self.realm.object(ofType: (type(of: entity) as! Entity.Type), forPrimaryKey: entityId) {
                        self.realm.delete(entity)
                        found = true
                    }
                }
                result = found
            }
        }
        return result
    }
    
    override func removeEntities(_ entities: [T]) -> Bool {
        log.verbose("Removing objects: \(entities)")
        var result = false
        executor.executeAndWait {
            try! self.realm.write {
                for entity in entities {
                    let entity = self.realm.object(ofType: type(of: entity) as! Entity.Type, forPrimaryKey: entity.entityId!)
                    if let entity = entity {
                        self.realm.delete(entity)
                        result = true
                    }
                }
            }
        }
        return result
    }
    
    override func removeEntitiesByQuery(_ query: Query) -> Int {
        log.verbose("Removing objects by query: \(query)")
        var result = 0
        executor.executeAndWait {
            try! self.realm.write {
                let results = self.results(query)
                result = results.count
                self.realm.delete(results)
            }
        }
        return result
    }
    
    override func removeAllEntities() {
        log.verbose("Removing all objects")
        executor.executeAndWait {
            try! self.realm.write {
                self.realm.delete(self.realm.objects(self.entityType))
            }
        }
    }
    
}

internal class RealmPendingOperation: Object, PendingOperationType {
    
    dynamic var requestId: String
    dynamic var date: Date
    
    dynamic var collectionName: String
    dynamic var objectId: String?
    
    dynamic var method: String
    dynamic var url: String
    dynamic var headers: Data
    dynamic var body: Data?
    
    init(request: URLRequest, collectionName: String, objectId: String?) {
        date = Date()
        requestId = request.value(forHTTPHeaderField: .requestId)!
        self.collectionName = collectionName
        self.objectId = objectId
        method = request.httpMethod ?? "GET"
        url = request.url!.absoluteString
        headers = try! JSONSerialization.data(withJSONObject: request.allHTTPHeaderFields!, options: [])
        body = request.httpBody
        super.init()
    }
    
    required init() {
        date = Date()
        requestId = ""
        collectionName = ""
        method = ""
        url = ""
        headers = Data()
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        date = Date()
        requestId = ""
        collectionName = ""
        method = ""
        url = ""
        headers = Data()
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        date = Date()
        requestId = ""
        collectionName = ""
        method = ""
        url = ""
        headers = Data()
        super.init(realm: realm, schema: schema)
    }
    
    func buildRequest() -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.allHTTPHeaderFields = try? JSONSerialization.jsonObject(with: headers, options: []) as! [String : String]
        if let body = body {
            request.httpBody = body
        }
        return request
    }
    
    override class func primaryKey() -> String? {
        return "requestId"
    }
    
}
