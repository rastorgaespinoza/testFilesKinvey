//
//  CacheManager.swift
//  Kinvey
//
//  Created by Victor Barros on 2016-01-20.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

internal class CacheManager: NSObject {
    
    fileprivate let persistenceId: String
    fileprivate let encryptionKey: Data?
    fileprivate let schemaVersion: UInt64
    
    init(persistenceId: String, encryptionKey: Data? = nil, schemaVersion: UInt64 = 0) {
        self.persistenceId = persistenceId
        self.encryptionKey = encryptionKey
        self.schemaVersion = schemaVersion
    }
    
    func cache<T: Persistable>(fileURL: URL? = nil, type: T.Type) -> Cache<T>? where T: NSObject {
        let fileManager = FileManager.default
        if let fileURL = fileURL {
            do {
                let baseURL = fileURL.deletingLastPathComponent()
                if !fileManager.fileExists(atPath: baseURL.path) {
                    try! fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)
                }
            }
        }
        
        return RealmCache<T>(persistenceId: persistenceId, fileURL: fileURL, encryptionKey: encryptionKey, schemaVersion: schemaVersion)
    }
    
    func fileCache(fileURL: URL? = nil) -> FileCache? {
        return RealmFileCache(persistenceId: persistenceId, fileURL: fileURL, encryptionKey: encryptionKey, schemaVersion: schemaVersion)
    }
    
    func clearFiles() {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let basePath = (path as NSString).appendingPathComponent(persistenceId) + "files"
            
            let fileManager = FileManager.default
            
            var isDirectory = ObjCBool(false)
            let exists = fileManager.fileExists(atPath: basePath, isDirectory: &isDirectory)
            if exists && isDirectory.boolValue {
                if let files = try? fileManager.subpathsOfDirectory(atPath: basePath) {
                    for file in files {
                        do {
                            try fileManager.removeItem(atPath: file)
                        } catch {
                            //ignore possible errors if for any reason is not possible to delete the file
                        }
                    }
                }
            }
        }
    }
    
    func clearAll(_ tag: String? = nil) {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let basePath = (path as NSString).appendingPathComponent(persistenceId)
            
            let fileManager = FileManager.default
            
            var isDirectory = ObjCBool(false)
            let exists = fileManager.fileExists(atPath: basePath, isDirectory: &isDirectory)
            if exists && isDirectory.boolValue {
                var array = try! fileManager.subpathsOfDirectory(atPath: basePath)
                array = array.filter({ (path) -> Bool in
                    return path.hasSuffix(".realm") && (tag == nil || path.caseInsensitiveCompare(tag! + ".realm") == .orderedSame)
                })
                for realmFile in array {
                    var realmConfiguration = Realm.Configuration.defaultConfiguration
                    realmConfiguration.fileURL = URL(fileURLWithPath: (basePath as NSString).appendingPathComponent(realmFile))
                    if let encryptionKey = encryptionKey {
                        realmConfiguration.encryptionKey = encryptionKey
                    }
                    if let realm = try? Realm(configuration: realmConfiguration) , !realm.isEmpty {
                        try! realm.write {
                            realm.deleteAll()
                        }
                    }
                }
            }
        }
    }
    
}
