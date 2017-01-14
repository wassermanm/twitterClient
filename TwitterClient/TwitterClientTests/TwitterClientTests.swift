//
//  TwitterClientTests.swift
//  TwitterClientTests
//
//  Created by Michael Wasserman on 2016-09-09.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import XCTest
@testable import TwitterClient

class TwitterClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        DataManagerAsyc.sharedInstance.logOut()
        super.tearDown()
    }
    
    func testLogin() {
        let asyncExpectation = expectation(description: "login")
        DataManagerAsyc.sharedInstance.login("tester", password: "password") { (success, message) in
            if success {
                asyncExpectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetTweetsForUser() {
        let asyncExpectation = expectation(description: "getTweetsForUser")
        DataManagerAsyc.sharedInstance.getTweetsForUser() { (success, message) in
            if success {
                if DataManagerAsyc.sharedInstance.tweets.count == 2 {
                    asyncExpectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
    func testAddTweet() {
        let asyncExpectation = expectation(description: "login")
        DataManagerAsyc.sharedInstance.login("tester", password: "password") { (success, message) in
            if success {
                DataManagerAsyc.sharedInstance.addTweet("someTweet", completion: { (success, message) in
                    if success {
                        if DataManagerAsyc.sharedInstance.newTweets.count == 1 {
                            asyncExpectation.fulfill()
                        }
                    }
                })
            }
        }
        
        self.waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
        }
    }
    
}
