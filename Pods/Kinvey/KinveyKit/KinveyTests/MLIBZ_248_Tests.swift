//
//  MLIBZ_248_Tests.swift
//  KinveyKit
//
//  Created by Victor Barros on 2015-04-30.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

import UIKit
import XCTest

class MLIBZ_248_Tests: KCSTestCase {
    
    class MockURLProtocol: NSURLProtocol {
        
        override class func canInitWithRequest(request: NSURLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
            return request
        }
        
        override func startLoading() {
            let response = NSHTTPURLResponse(
                URL: request.URL!,
                statusCode: 500,
                HTTPVersion: "1.1",
                headerFields: [
                    "Content-Type" : "application/json"
                ]
            )!
            client!.URLProtocol(
                self,
                didReceiveResponse: response,
                cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed
            )
            let data = try! NSJSONSerialization.dataWithJSONObject(
                [],
                options: NSJSONWritingOptions())
            client!.URLProtocol(
                self,
                didLoadData: data
            )
            client!.URLProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {
        }
        
    }

    override func setUp() {
        super.setUp()
        
        let config = KCSClientConfiguration(
            appKey: "kid_-1WAs8Rh2",
            secret: "2f355bfaa8cb4f7299e914e8e85d8c98",
            options: nil
        )
        KCSClient.sharedClient().initializeWithConfiguration(config)
        
        weak var expectationLogin = expectationWithDescription("login")
        
        KCSUser.createAutogeneratedUser(
            nil,
            completion: { (user: KCSUser!, error: NSError!, actionResult: KCSUserActionResult) -> Void in
                expectationLogin?.fulfill()
            }
        )
        
        waitForExpectationsWithTimeout(30, handler: { (error: NSError?) -> Void in
            expectationLogin = nil
        })
        
        KCSURLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        KCSURLProtocol.unregisterClass(MockURLProtocol.self)
        
        super.tearDown()
    }

    func test() {
        let collection = KCSCollection(fromString: "CollectionWith500BL", ofClass: NSMutableDictionary.self)
        let store = KCSAppdataStore(collection: collection, options: nil)
        
        weak var expectationQuery = expectationWithDescription("query")
        
        store.queryWithQuery(
            KCSQuery(),
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                XCTAssertNil(objectsOrNil)
                XCTAssertNotNil(errorOrNil)
                XCTAssertEqual(errorOrNil.localizedDescription, "Kinvey requires a JSON Object as response body")
                
                expectationQuery?.fulfill()
            },
            withProgressBlock: nil
        )
        
        waitForExpectationsWithTimeout(30, handler: { (error: NSError?) -> Void in
            expectationQuery = nil
        })
    }

}
