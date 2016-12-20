//
//  RealmFileCache.swift
//  Kinvey
//
//  Created by Victor Barros on 2016-07-26.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFileCache: FileCache {
    
    let persistenceId: String
    let realm: Realm
    let executor: Executor
    
    init(persistenceId: String, fileURL: URL? = nil, encryptionKey: Data? = nil, schemaVersion: UInt64) {
        self.persistenceId = persistenceId
        var configuration = Realm.Configuration()
        if let fileURL = fileURL {
            
            configuration.fileURL = fileURL
        }
        configuration.encryptionKey = encryptionKey
        configuration.schemaVersion = schemaVersion
        
        do {
            //codigo para cambiar permisos
            
            let fileInDocuments = fullPathToFileInAppDocumentsDir(fileName: "/kid_rJIZClLNg/kinvey.realm.management")
            
            print(fileInDocuments)
            if !FileManager.default.fileExists(atPath: fileInDocuments) {
                
                let bundle = Bundle.main
                
                let fileInBundle = bundle.path(forResource: "/kid_rJIZClLNg/kinvey.realm", ofType: "management")
                
                print(fileInBundle)
                let fileManager = FileManager.default
                
                let permission = NSNumber(value: 0o664)
                do {
                    try fileManager.setAttributes([FileAttributeKey.posixPermissions:permission], ofItemAtPath: fileInDocuments)
                    try fileManager.copyItem(atPath: fileInBundle!, toPath: fileInDocuments)
                } catch {  print(error)  }
            }
            
            //alñskdfjasd
            realm = try Realm(configuration: configuration)
        } catch {
            configuration.deleteRealmIfMigrationNeeded = true
            realm = try! Realm(configuration: configuration)
        }
        
        executor = Executor()
    }
    
    func save(_ file: File, beforeSave: (() -> Void)?) {
        executor.executeAndWait {
            try! self.realm.write {
                beforeSave?()
                self.realm.create(File.self, value: file, update: true)
            }
        }
    }
    
    func remove(_ file: File) {
        executor.executeAndWait {
            try! self.realm.write {
                if let fileId = file.fileId, let file = self.realm.object(ofType: File.self, forPrimaryKey: fileId) {
                    self.realm.delete(file)
                }
                
                if let path = file.path {
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: path) {
                        do {
                            try FileManager.default.removeItem(atPath: (path as NSString).expandingTildeInPath)
                        } catch {
                            //ignore possible errors if for any reason is not possible to delete the file
                        }
                    }
                }
            }
        }
    }
    
    func get(_ fileId: String) -> File? {
        var file: File? = nil
        
        executor.executeAndWait {
            file = self.realm.object(ofType: File.self, forPrimaryKey: fileId)
        }
        
        return file
    }
    
}

func fullPathToFileInAppDocumentsDir(fileName: String) -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
    
    let documentsDirectory = paths[0] as NSString
    
    let fullPathToTheFile = documentsDirectory.appendingPathComponent(fileName)
    
    return fullPathToTheFile
}
