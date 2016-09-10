//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func render(tweetData:Tweets) {
        tweetContentLabel.text = tweetData.tweet
        userNameLabel.text     = tweetData.author
        guard let dateOfTweet  = tweetData.dateOfTweet else {
            timeLabel.text = ""
            return
        }
        timeLabel.text = NSDate.fromDateToString(dateOfTweet)
    }
}

extension NSDate {
    class func fromDateToString(dateToConvert:NSDate) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(dateToConvert)
        return dateString
    }
}