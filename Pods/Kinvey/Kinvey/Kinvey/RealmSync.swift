//
//  RealmSync.swift
//  Kinvey
//
//  Created by Victor Barros on 2016-06-20.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSync<T: Persistable>: Sync<T> where T: NSObject {
    
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
        realm = try! Realm(configuration: configuration)
        let className = NSStringFromClass(T.self).components(separatedBy: ".").last!
        objectSchema = realm.schema[className]!
        propertyNames = objectSchema.properties.map { return $0.name }
        executor = Executor()
        super.init(persistenceId: persistenceId)
        log.debug("Sync File: \(self.realm.configuration.fileURL!.path)")
    }

    required init(persistenceId: String) {
        let message = "Method \(#function) must be overridden"
        log.severe(message)
        fatalError(message)
    }
    
    override func createPendingOperation(_ request: URLRequest, objectId: String?) -> RealmPendingOperation {
        return RealmPendingOperation(request: request, collectionName: T.collectionName(), objectId: objectId)
    }
    
    override func savePendingOperation(_ pendingOperation: RealmPendingOperation) {
        log.verbose("Saving pending operation: \(pendingOperation)")
        executor.executeAndWait {
            try! self.realm.write {
                self.realm.create(RealmPendingOperation.self, value: pendingOperation, update: true)
            }
        }
    }
    
    override func pendingOperations() -> Results<RealmPendingOperation> {
        return pendingOperations(nil)
    }
    
    override func pendingOperations(_ objectId: String?) -> Results<RealmPendingOperation> {
        log.verbose("Fetching pending operations by object id: \(objectId)")
        var results: Results<RealmPendingOperation>?
        executor.executeAndWait {
            var realmResults = self.realm.objects(RealmPendingOperation.self)
            if let objectId = objectId {
                realmResults = realmResults.filter("objectId == %@", objectId)
            }
            results = Results(realmResults)
        }
        return results!
    }
    
    override func removePendingOperation(_ pendingOperation: RealmPendingOperation) {
        log.verbose("Removing pending operation: \(pendingOperation)")
        executor.executeAndWait {
            try! self.realm.write {
                self.realm.delete(pendingOperation)
            }
        }
    }
    
    override func removeAllPendingOperations() {
        removeAllPendingOperations(nil, methods: nil)
    }
    
    override func removeAllPendingOperations(_ objectId: String?) {
        removeAllPendingOperations(objectId, methods: nil)
    }
    
    override func removeAllPendingOperations(_ objectId: String?, methods: [String]?) {
        log.verbose("Removing pending operations by object id: \(objectId)")
        executor.executeAndWait {
            try! self.realm.write {
                var realmResults = self.realm.objects(RealmPendingOperation.self)
                if let objectId = objectId {
                    realmResults = realmResults.filter("objectId == %@", objectId)
                }
                if let methods = methods {
                    realmResults = realmResults.filter("method in %@", methods)
                }
                self.realm.delete(realmResults)
            }
        }
    }
    
}
