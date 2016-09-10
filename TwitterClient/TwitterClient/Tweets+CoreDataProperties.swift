//
//  Tweets+CoreDataProperties.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweets {

    @NSManaged var tweet: String?
    @NSManaged var dateOfTweet: NSDate?
    @NSManaged var author: String?
    @NSManaged var userName: String?

}
