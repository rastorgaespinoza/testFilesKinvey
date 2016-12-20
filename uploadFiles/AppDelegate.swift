//
//  AppDelegate.swift
//  uploadFiles
//
//  Created by admin on 12/20/16.
//  Copyright © 2016 solu4b. All rights reserved.
//

import UIKit
import Kinvey

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Kinvey.sharedClient.initialize(
            appKey: "kid_rJIZClLNg",
            appSecret: "1ef2120cadd94c0eb82a06c1f50c8868"
        )
        
        
//        FileManager.default.
        return true
    }
    
//    func testPermissions() {
//        let types: [Int16] = [0o666, 0o664, 0o662, 0o660, 0o646, 0o626, 0o606, 0o466, 0o266, 0o066]
//        for t in types {
//            testCreateFile(permissions: t)
//        }
//    }
//    
//    func testCreateFile(permissions: Int16)  {
//        let attributes: [String:AnyObject] = [NSFilePosixPermissions: NSNumber(short: permissions)]
//        
//        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let filename = "filename\(permissions.description)"
//        let path = "\(directory)/\(filename)"
//        
//        let fileManager = FileManager.default
//        let success = fileManager.createFile(atPath: path, contents: nil, attributes: attributes)
//        
//        if success && fileManager.isWritableFile(atPath: path) && fileManager.isReadableFile(atPath: path) {
//            let octal = String(format:"%o", permissions)
//            NSLog("It worked for \(octal)")
//        }
//    }
    
    
    

}

func changePermission(){
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
    
}

func fullPathToFileInAppDocumentsDir(fileName: String) -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
    
    let documentsDirectory = paths[0] as NSString
    
    let fullPathToTheFile = documentsDirectory.appendingPathComponent(fileName)
    
    return fullPathToTheFile
}

