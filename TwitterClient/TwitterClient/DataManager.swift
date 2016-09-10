//
//  DataManager.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public let dataManager = DataManager.sharedInstance

public class DataManager {
    
    private init(){}
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    internal static let sharedInstance = DataManager()
    
    //MARK: - Data Manipulation Methods
    //in this method I am looking up the user and returning an (fake) authorization key as a token to indicated
    //that the user has been found and thus successfully logged in
    func login(userName:String, password:String) throws -> String {
        var authKey = ""
        let fetchRequest       = NSFetchRequest(entityName: "User")
        let loginPredicate     = NSPredicate(format: "userName = %@ AND password = %@", userName, password)
        fetchRequest.predicate = loginPredicate
        do {
            let objects = try managedObjectContext.executeFetchRequest(fetchRequest) as? [User]
            if let results = objects {
                if results.count > 0 {
                    authKey = "ASDFADSFASDFASDFAS" //a token to indicate successful login - ideally would come from backend
                    setUpUserDefaults(userName)
                } else {
                    authKey = ""
                }
            }
        } catch {
            print("error retreiving user: \(error)")
            throw DataError.Error
        }
        return authKey
    }
    
    //gets all tweets for a user - called only the first time the user views tweets
    func getTweetsForUser() throws -> Array<Tweets> {
        var tweets             = Array<Tweets>()
        let defaults           = NSUserDefaults.standardUserDefaults()
        guard let userName     = defaults.stringForKey("currentUser") else {
            throw DataError.Error
        }
        let fetchRequest       = NSFetchRequest(entityName: "Tweets")
        let tweetsPredicate    = NSPredicate(format: "userName = %@", userName)
        fetchRequest.predicate = tweetsPredicate
        do {
            let objects = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Tweets]
            if let results = objects {
                for tweet in results {
                    tweets.append(tweet)
                }
            }
        } catch {
            print("error retreiving user: \(error)")
            throw DataError.Error
        }
        return tweets
    }
    
    func addTweet(tweetText:String) throws {
        let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweets", inManagedObjectContext: managedObjectContext) as! Tweets
        
        let defaults      = NSUserDefaults.standardUserDefaults()
        tweet.author      = defaults.stringForKey("currentUser")
        tweet.dateOfTweet = NSDate()
        tweet.tweet       = tweetText
        tweet.userName    = defaults.stringForKey("currentUser")
        tweet.newTweet    = true
        do {
            try  self.managedObjectContext.save()
        } catch {
            print("error trying to save tweet: \(error)")
            throw DataError.Error
        }
    }
    
    //retrieves "new" tweets - called only when the user is logged in and views tweets after the first time
    func getNewTweets() throws -> Array<Tweets> {
        var tweets         = Array<Tweets>()
        let defaults       = NSUserDefaults.standardUserDefaults()
        guard let userName = defaults.stringForKey("currentUser") else {
            print("no userName - getNewTweets()")
            return tweets
        }
        
        let fetchRequest       = NSFetchRequest(entityName: "Tweets")
        let tweetsPredicate    = NSPredicate(format: "userName = %@ AND newTweet=%@", userName, true)
        fetchRequest.predicate = tweetsPredicate
        
        do {
            let objects = try managedObjectContext.executeFetchRequest(fetchRequest) as? [Tweets]
            if let results = objects {
                for tweet in results {
                    tweets.append(tweet)
                }
            }
        } catch {
            print("error retreiving user: \(error)")
            throw DataError.Error
        }
        makeTweetsAsOld(tweets)
        return tweets
    }
    
    //MARK: - Private Helper Methods
    
    //updates "new" tweets making them old tweets as soon as they are retrieved for the user
    private func makeTweetsAsOld(tweets:Array<Tweets>) {
        for tweet in tweets {
            tweet.newTweet = false
        }
        do {
            try  self.managedObjectContext.save()
        } catch {
            //fail silently - there is no need to alert the user to this error
            print("error trying to mark tweets as old: \(error)")
        }
    }
    
    private func setUpUserDefaults(userName:String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userName, forKey: "currentUser")
        if defaults.stringForKey("firstLogin") == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "firstLogin")
        }
    }
    
    //MARK: - Logout Methods
    
    func logOut() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUser")
    }
    
    //MARK: - Data Setup Methods
    
    func loadTweets() {
        let filePath = NSBundle.mainBundle().pathForResource("Tweets",ofType:"json")
        guard (filePath != nil) else {
            print("can't find Tweets.json file")
            return
        }
        
        if let data = NSData(contentsOfFile: filePath!) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                for item in json as! [[String:String]] {
                    let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweets", inManagedObjectContext: managedObjectContext) as! Tweets
                    guard let author = item["author"], let dateOfTweet = item["dateOfTweet"], let tweetText = item["tweet"], let userName = item["userName"] else {
                        print("data error in Tweets.json file")
                        return
                    }
                    tweet.author      = author
                    tweet.dateOfTweet = NSDate.stringToDate(dateOfTweet)
                    tweet.tweet       = tweetText
                    tweet.userName    = userName
                }
                try self.managedObjectContext.save()
            } catch {
                print("error serializing user JSON from Tweets.json: \(error)")
            }
        }
    }
    
    func loadUser() {
        let filePath = NSBundle.mainBundle().pathForResource("User",ofType:"json")
        guard (filePath != nil) else {
            print("can't find User.json file")
            return
        }
        
        if let data = NSData(contentsOfFile: filePath!) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                for item in json as! [[String:String]] {
                    let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as! User
                    guard let userName = item["userName"], let password = item["password"] else {
                        print("data error in User.json file")
                        return
                    }
                    user.userName = userName
                    user.password = password
                }
                try self.managedObjectContext.save()
            } catch {
                print("error serializing user JSON from User.json: \(error)")
            }
        }
    }
    
    //MARK: - Methods For Tests
    func deleteUser() {
        let fetchRequest = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(deleteRequest)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.removeObjectForKey("firstLogin")
        } catch {
            // TODO: handle the error
            print("ERROR DELETING DATA: \(error)")
        }
    }
    
    func deleteTweets() {
        let fetchRequest = NSFetchRequest(entityName: "Tweets")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(deleteRequest)
        } catch {
            // TODO: handle the error
            print("ERROR DELETING DATA: \(error)")
        }
    }
    
}