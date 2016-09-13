//
//  DataManagerAsyc.swift
//  TwitterClient
//
//  Created by michael wasserman on 2016-09-12.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import Foundation
import UIKit

public let dataManagerAsyc = DataManagerAsyc.sharedInstance

public class DataManagerAsyc {

    private init(){}
    internal static let sharedInstance = DataManagerAsyc()
    var tweets    = Array<Tweet>()
    var newTweets = Array<Tweet>()
    
    
    func login(userName: String, password: String, completion: (success: Bool, message: String?) -> ()) {
        let loginObject = ["userName": userName, "password": password]
        post(clientURLRequest("auth/local", params: loginObject)) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if userName == "tester" && password == "password" {
                    completion(success: true, message: nil)
                } else {
                    //this could be set to something else to indicate that the network call failed
                    var message = "bad password"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(success: false, message: message)
                }
            })
        }
    }
    
    func getTweetsForUser( completion: (success: Bool, message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { [weak self] (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //lets set up a few tweets
                self?.makeSampleTweets()
                if success {
                    completion(success: true, message: nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(success: true, message: message)
                }
            })
        }
    }
    
    func addTweet(tweetText:String,  completion: (success: Bool, message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { [weak self] (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //lets set up a few tweets
                self?.makeNewTweet(tweetText)
                if success {
                    completion(success: true, message: nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(success: true, message: message)
                }
            })
        }
    }

    func getNewTweets( completion: (success: Bool, message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { (success, object) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if success {
                    completion(success: true, message: nil)
                    self.newTweets.removeAll()
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(success: true, message: message)
                }
            })
        }
    }
    
    func logOut() {
        self.tweets.removeAll()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUser")
    }
    
    //MARK: - Helper Methods
    private func setUpUserDefaults(userName:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userName, forKey: "currentUser")
        if defaults.stringForKey("firstLogin") == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "firstLogin")
        }
    }
    
    private func makeNewTweet(tweetText:String) {
        let tweet = Tweet()
        let defaults      = NSUserDefaults.standardUserDefaults()
        tweet.author      = defaults.stringForKey("currentUser")
        tweet.dateOfTweet = NSDate()
        tweet.tweet       = tweetText
        tweet.userName    = defaults.stringForKey("currentUser")
        tweet.newTweet    = true
        self.newTweets.append(tweet)
    }
    
    
    private func makeSampleTweets() {
        let tweetOne = Tweet()
        tweetOne.author = "tester"
        let calendar = NSCalendar.currentCalendar()
        tweetOne.dateOfTweet = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
        tweetOne.newTweet = false
        tweetOne.tweet = "this is an old tweet"
        tweetOne.userName = "tester"
        self.tweets.append(tweetOne)
        
        let tweetTwo = Tweet()
        tweetTwo.author = "tester"
        tweetTwo.dateOfTweet = calendar.dateByAddingUnit(.Day, value: -5, toDate: NSDate(), options: [])
        tweetTwo.newTweet = false
        tweetTwo.tweet = "this is an older tweet"
        tweetTwo.userName = "tester"
        self.tweets.append(tweetTwo)
    }
    
    
    //MARK: - HTTP Handling Methods
    private func clientURLRequest(path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://someURL.com/"+path)!)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                paramString += "\(escapedKey)=\(escapedValue)&"
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        return request
    }
    
    private func post(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    private func get(request: NSMutableURLRequest, completion: (success: Bool, object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()) {
        request.HTTPMethod = method
        completion(success: true, object: nil)
        
        /*let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    completion(success: true, object: json)
                } else {
                    completion(success: false, object: json)
                }
            } else {
                print("HERE")
            }
            }.resume()*/
    }
    
}