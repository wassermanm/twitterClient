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
    var isFirstLoad  = true
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Tweets"
        guard let tweets = DataManager.sharedInstance.getTweetsForUser("tester") else {
            let alertController = UIAlertController(title: "Account Issue", message: "Problem accessing account. Please try again later", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if tweets.count < 1 {
            let alertController = UIAlertController(title: "No Tweets", message: "No Tweets found!", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        tweetsToShow = tweets.sort{($0.dateOfTweet)!.compare($1.dateOfTweet!) == .OrderedDescending}
        isFirstLoad = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isFirstLoad {
            let newTweets = DataManager.sharedInstance.getNewTweets()
            if newTweets.count > 0 {
                let tempTweets = tweetsToShow + newTweets
                tweetsToShow = tempTweets.sort{($0.dateOfTweet)!.compare($1.dateOfTweet!) == .OrderedDescending}
                tweetsTableView.reloadData()
            }
        }
    }
    
    //MARK: - UITableViewDataSource and UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tweetsToShow.count)
        return tweetsToShow.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetCell
        cell.render(tweetsToShow[indexPath.row])
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //MARK: - IBAction Methods
    @IBAction func logoutAction(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("currentUser")
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

