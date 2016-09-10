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

