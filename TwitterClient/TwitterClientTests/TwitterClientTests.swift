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
        DataManager.sharedInstance.deleteUser()
        DataManager.sharedInstance.deleteTweets()
        DataManager.sharedInstance.logOut()
        super.tearDown()
    }
    
    func testLogin() {
        do {
            let authKey = try DataManager.sharedInstance.login("tester", password: "password")
            XCTAssert(authKey != "")
        } catch {
            print("failure")
        }
        
        do {
            let authKey = try DataManager.sharedInstance.login("test", password: "password")
            XCTAssert(authKey == "")
        } catch {
            print("failure")
        }
    }
    
    func testGetTweetsForUser() {
        do {
            //this should only be run if data is loaded at first run of app
            try DataManager.sharedInstance.login("tester", password: "password")
            let tweets = try DataManager.sharedInstance.getTweetsForUser()
            XCTAssert(tweets.count == 17)
        } catch {
            print("failure")
        }
    }
    
    func testAddTweet() {
        do {
            try DataManager.sharedInstance.login("tester", password: "password")
            try DataManager.sharedInstance.addTweet("this is a new tweet")
            let tweets = try DataManager.sharedInstance.getTweetsForUser()
            XCTAssert(tweets.count == 18)
        } catch {
            print("failure")
        }
    }
    
    func testGetNewTweets() {
        do {
            try DataManager.sharedInstance.login("tester", password: "password")
            try DataManager.sharedInstance.addTweet("this is a new tweet")
            let tweets = try DataManager.sharedInstance.getNewTweets()
            XCTAssert(tweets.count == 1)
        } catch {
            print("failure")
        }
    }
    
}
