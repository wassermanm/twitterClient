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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    internal static let sharedInstance = DataManager()
    
    //in this method I am looking up the user and returning an (fake) authorization key
    func login(userName:String, password:String) -> String? {
        var authKey:String?
        let fetchRequest       = NSFetchRequest(entityName: "User")
        let loginPredicate     = NSPredicate(format: "userName = %@ AND password = %@", userName, password)
        fetchRequest.predicate = loginPredicate
        do {
            let objects = try managedObjectContext.executeFetchRequest(fetchRequest) as? [User]
            if let results = objects {
                if results.count > 0 {
                    authKey = "ASDFADSFASDFASDFAS" //this should come from backend - a token for subsequent calls
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(userName, forKey: "currentUser")
                } else {
                    authKey = nil
                }
            }
        } catch {
            print("error retreiving user: \(error)")
        }
        return authKey
    }
    
    func getTweetsForUser(userName:String) -> Array<Tweets>? {
        var tweets             = Array<Tweets>()
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
        }
        return tweets
    }
    
    func addTweet(tweetText:String) {
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
        }
    }
    
    func getNewTweets() -> Array<Tweets> {
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
        }
        makeTweetsAsOld(tweets)
        return tweets
    }
    
    private func makeTweetsAsOld(tweets:Array<Tweets>) {
        for tweet in tweets {
            tweet.newTweet = false
        }
        do {
            try  self.managedObjectContext.save()
        } catch {
            print("error trying to mark tweets as old: \(error)")
        }

    }
}