//
//  MLIBZ_256_Tests.swift
//  KinveyKit
//
//  Created by Victor Barros on 2015-04-30.
//  Copyright (c) 2015 Kinvey. All rights reserved.
//

import UIKit
import XCTest

class MLIBZ_256_Tests: KCSTestCase {
    
    static let appId = "kid_-1WAs8Rh2"
    static let appSecret = "2f355bfaa8cb4f7299e914e8e85d8c98"
    
    var store: KCSCachedStore! = nil
    
    var resultsCache: [AnyObject]? = nil
    
    class MockURLProtocol: NSURLProtocol {
        
        static var urlError: NSError!
        
        override class func canInitWithRequest(request: NSURLRequest) -> Bool {
            return request.URL!.absoluteString != "https://baas.kinvey.com/user/\(appId)/login"
        }
        
        override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
            return request
        }
        
        override func startLoading() {
            client!.URLProtocol(
                self,
                didFailWithError: MockURLProtocol.urlError
            )
        }
        
    }
    
    override func setUp() {
        super.setUp()
        
        let clazz = MLIBZ_256_Tests.self
        
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            clazz.appId,
            withAppSecret: clazz.appSecret,
            usingOptions: nil
        )
        
        class OfflineSaveDelegate: NSObject, KCSOfflineUpdateDelegate {
            
            @objc private func shouldDeleteObject(objectId: String!, inCollection collectionName: String!, lastAttemptedDeleteTime time: NSDate!) -> Bool {
                return true
            }
            
            @objc private func shouldEnqueueObject(objectId: String!, inCollection collectionName: String!, onError error: NSError!) -> Bool {
                return true
            }
            
            @objc private func shouldSaveObject(objectId: String!, inCollection collectionName: String!, lastAttemptedSaveTime saveTime: NSDate!) -> Bool {
                return true
            }
            
        }
        
        let delegate = OfflineSaveDelegate()
        KCSClient.sharedClient().setOfflineDelegate(delegate)
        
        weak var expectationLogin = expectationWithDescription("login")
        
        KCSUser.createAutogeneratedUser(
            nil,
            completion: { (user: KCSUser!, error: NSError!, actionResult: KCSUserActionResult) -> Void in
                XCTAssertNotNil(user)
                XCTAssertNil(error)
                
                expectationLogin?.fulfill()
            }
        )
        
        weak var expectationSave = expectationWithDescription("save")
        
        class Object : NSObject {
            
            dynamic var objectId: String?
            dynamic var policyId: String?
            
            private override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
                return [
                    "objectId" : KCSEntityKeyId,
                    "policyId" : "policyId"
                ]
            }
            
        }
        
        let collection = KCSCollection(fromString: "vehicles", ofClass: NSMutableDictionary.self)
        store = KCSCachedStore(
            collection: collection,
            options: [
                KCSStoreKeyCachePolicy : KCSCachePolicy.LocalFirst.rawValue,
                KCSStoreKeyOfflineUpdateEnabled : true
            ]
        )
        
        let obj = Object()
        obj.policyId = "5"
        
        store.saveObject(
            obj,
            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                XCTAssertNotNil(objectsOrNil)
                XCTAssertNil(errorOrNil)
                
                expectationSave?.fulfill()
            },
            withProgressBlock: nil
        )
        
        waitForExpectationsWithTimeout(30, handler: nil)
        
        weak var expectationQuery = expectationWithDescription("query")
        
        //Caching the results
        store.queryWithQuery(
            KCSQuery(onField: "policyId", withExactMatchForValue: "5"),
            withCompletionBlock: { (results: [AnyObject]!, error: NSError!) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                
                self.resultsCache = results
                
                expectationQuery?.fulfill()
            },
            withProgressBlock: nil,
            cachePolicy: KCSCachePolicy.NetworkFirst
        )
        
        waitForExpectationsWithTimeout(90, handler: nil)
        
        KCSURLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDown() {
        KCSURLProtocol.unregisterClass(MockURLProtocol.self)
        
        super.tearDown()
    }
    
    override func runTest() {
        weak var expectationQuery1 = expectationWithDescription("query1")
        
        var firstTime = true;
        store.queryWithQuery(
            KCSQuery(onField: "policyId", withExactMatchForValue: "5"),
            withCompletionBlock: { (results: [AnyObject]!, error: NSError!) -> Void in
                if (firstTime) {
                    XCTAssertNil(error)
                    XCTAssertNotNil(results)
                    
                    if (results != nil) {
                        XCTAssertEqual(results.count, self.resultsCache!.count)
                        XCTAssertEqual(results as! [NSObject], self.resultsCache as! [NSObject])
                    }
                    
                    firstTime = false
                } else {
                    expectationQuery1?.fulfill()
                }
            },
            withProgressBlock: nil,
            cachePolicy: KCSCachePolicy.Both
        )
        
        waitForExpectationsWithTimeout(90, handler: nil)
        
        weak var expectationQuery2 = expectationWithDescription("query2")
        
        store.queryWithQuery(
            KCSQuery(onField: "policyId", withExactMatchForValue: "5"),
            withCompletionBlock: { (results: [AnyObject]!, error: NSError!) -> Void in
                XCTAssertNil(error)
                XCTAssertNotNil(results)
                
                if (results != nil) {
                    XCTAssertEqual(results.count, self.resultsCache!.count)
                    XCTAssertEqual(results as! [NSObject], self.resultsCache as! [NSObject])
                }
                
                expectationQuery2?.fulfill()
            },
            withProgressBlock: nil,
            cachePolicy: KCSCachePolicy.LocalOnly
        )
        
        waitForExpectationsWithTimeout(60, handler: nil)
    }
    
    func testTimedOut() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorTimedOut,
            userInfo: [
                NSLocalizedDescriptionKey : "The connection timed out."
            ]
        )
        runTest()
    }
    
    func testCannotFindHost() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorCannotFindHost,
            userInfo: [
                NSLocalizedDescriptionKey : "A server with the specified hostname could not be found."
            ]
        )
        runTest()
    }
    
    func testCannotConnectToHost() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorCannotConnectToHost,
            userInfo: [
                NSLocalizedDescriptionKey : "The connection failed because a connection cannot be made to the host."
            ]
        )
        runTest()
    }
    
    func testNetworkConnectionLost() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNetworkConnectionLost,
            userInfo: [
                NSLocalizedDescriptionKey : "The connection failed because the network connection was lost."
            ]
        )
        runTest()
    }

    func testDNSLookupFailed() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorDNSLookupFailed,
            userInfo: [
                NSLocalizedDescriptionKey : "The connection failed because the DNS lookup failed."
            ]
        )
        runTest()
    }
    
    func testNotConnectedToInternet() {
        MockURLProtocol.urlError = NSError(
            domain: NSURLErrorDomain,
            code: NSURLErrorNotConnectedToInternet,
            userInfo: [
                NSLocalizedDescriptionKey : "The connection failed because the device is not connected to the internet."
            ]
        )
        runTest()
    }

}
