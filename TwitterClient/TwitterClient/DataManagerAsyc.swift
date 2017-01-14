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

open class DataManagerAsyc {

    fileprivate init(){}
    internal static let sharedInstance = DataManagerAsyc()
    var tweets    = Array<Tweet>()
    var newTweets = Array<Tweet>()
    
    
    func login(_ userName: String, password: String, completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        let loginObject = ["userName": userName, "password": password]
        post(clientURLRequest("auth/local", params: loginObject as Dictionary<String, AnyObject>?)) { (success, object) in
            DispatchQueue.main.async(execute: { () -> Void in
                if userName == "tester" && password == "password" {
                    completion(true, nil)
                } else {
                    //this could be set to something else to indicate that the network call failed
                    var message = "bad password"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(false, message)
                }
            })
        }
    }
    
    func getTweetsForUser( _ completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { [weak self] (success, object) in
            DispatchQueue.main.async(execute: { () -> Void in
                //lets set up a few tweets
                self?.makeSampleTweets()
                if success {
                    completion(true, nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(true, message)
                }
            })
        }
    }
    
    func addTweet(_ tweetText:String,  completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { [weak self] (success, object) in
            DispatchQueue.main.async(execute: { () -> Void in
                //lets set up a few tweets
                self?.makeNewTweet(tweetText)
                if success {
                    completion(true, nil)
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(true, message)
                }
            })
        }
    }

    func getNewTweets( _ completion: @escaping (_ success: Bool, _ message: String?) -> ()) {
        get(clientURLRequest("tweets/local")) { (success, object) in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    completion(true, nil)
                    self.newTweets.removeAll()
                } else {
                    var message = "there was an error"
                    if let object = object, let passedMessage = object["message"] as? String {
                        message = passedMessage
                    }
                    completion(true, message)
                }
            })
        }
    }
    
    func logOut() {
        self.tweets.removeAll()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "currentUser")
    }
    
    //MARK: - Helper Methods
    fileprivate func setUpUserDefaults(_ userName:String) {
        let defaults = UserDefaults.standard
        defaults.setValue(userName, forKey: "currentUser")
        if defaults.string(forKey: "firstLogin") == nil {
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "firstLogin")
        }
    }
    
    fileprivate func makeNewTweet(_ tweetText:String) {
        let tweet = Tweet()
        let defaults      = UserDefaults.standard
        tweet.author      = defaults.string(forKey: "currentUser")
        tweet.dateOfTweet = Date()
        tweet.tweet       = tweetText
        tweet.userName    = defaults.string(forKey: "currentUser")
        tweet.newTweet    = true
        self.newTweets.append(tweet)
    }
    
    
    fileprivate func makeSampleTweets() {
        let tweetOne = Tweet()
        tweetOne.author = "tester"
        let calendar = Calendar.current
        tweetOne.dateOfTweet = (calendar as NSCalendar).date(byAdding: .day, value: -2, to: Date(), options: [])
        tweetOne.newTweet = false
        tweetOne.tweet = "this is an old tweet"
        tweetOne.userName = "tester"
        self.tweets.append(tweetOne)
        
        let tweetTwo = Tweet()
        tweetTwo.author = "tester"
        tweetTwo.dateOfTweet = (calendar as NSCalendar).date(byAdding: .day, value: -5, to: Date(), options: [])
        tweetTwo.newTweet = false
        tweetTwo.tweet = "this is an older tweet"
        tweetTwo.userName = "tester"
        self.tweets.append(tweetTwo)
    }
    
    
    //MARK: - HTTP Handling Methods
    fileprivate func clientURLRequest(_ path: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: URL(string: "http://someURL.com/"+path)!)
        if let params = params {
            var paramString = ""
            for (key, value) in params {
                let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let escapedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                paramString += "\(escapedKey)=\(escapedValue)&"
            }
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = paramString.data(using: String.Encoding.utf8)
        }
        
        return request
    }
    
    fileprivate func post(_ request: NSMutableURLRequest, completion: (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "POST", completion: completion)
    }
    
    fileprivate func get(_ request: NSMutableURLRequest, completion: (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request, method: "GET", completion: completion)
    }
    
    
    fileprivate func dataTask(_ request: NSMutableURLRequest, method: String, completion: (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        completion(true, nil)
        
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
