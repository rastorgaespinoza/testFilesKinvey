//
//  KCSFileStoreMemoryTestsSwift.swift
//  KinveyKit
//
//  Created by Victor Barros on 2015-08-20.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

import UIKit
import XCTest

class KCSFileStoreMemoryTestsSwift: KCSTestCase {

    override func setUp() {
        super.setUp()
        
        setupKCS()
        createAutogeneratedUser()
    }
    
    override func tearDown() {
        KCSUser.activeUser()?.logout()
        
        super.tearDown()
    }
    
    func testUploadMemoryLeak() {
        weak var expectationUpload = expectationWithDescription("upload")
        
        XCTAssertEqual(0, KCSFile.referenceCount())
        XCTAssertEqual(0, KCSNSURLSessionFileOperation.referenceCount())
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("mavericks", withExtension: "jpg")
        KCSFileStore.uploadFile(
            url,
            options: nil,
            completionBlock: { (file: KCSFile!, error: NSError!) -> Void in
                XCTAssertEqual(1, KCSFile.referenceCount())
                XCTAssertEqual(1, KCSNSURLSessionFileOperation.referenceCount())
                
                expectationUpload?.fulfill()
            },
            progressBlock: nil
        )
        
        waitForExpectationsWithTimeout(60, handler: { (error: NSError?) -> Void in
            expectationUpload = nil
        })
        
        weak var expectationMemory = expectationWithDescription("memory")
        
        var running = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            while (running) {
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    if (KCSFile.referenceCount() == 0 && KCSNSURLSessionFileOperation.referenceCount() == 0) {
                        expectationMemory?.fulfill()
                    }
                })
            }
        })
        
        waitForExpectationsWithTimeout(10, handler: { (error: NSError?) -> Void in
            running = false
            expectationMemory = nil
        })
        
        XCTAssertEqual(0, KCSFile.referenceCount())
        XCTAssertEqual(0, KCSNSURLSessionFileOperation.referenceCount())
    }

}
