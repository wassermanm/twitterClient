//
//  ViewTweetsViewController.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import UIKit

class ViewTweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tweetsTableView: UITableView!
    var tweetsToShow = Array<Tweets>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tweets"
        guard let tweets = DataManager.sharedInstance.getTweetsForUser("tester") else {
            return
        }
        tweetsToShow = tweets
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsToShow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        cell.render(tweetsToShow[indexPath.row])
        
        return cell
    }
}

