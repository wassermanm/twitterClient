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
    var tweetsToShow = Array<Tweet>()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.title = "Tweets"
        var tweets = Array<Tweet>()
        if Reachability.isConnectedToNetwork() {
            tweets = DataManagerAsyc.sharedInstance.tweets
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        if tweets.count < 1 {
            let alertController = UIAlertController(title: "No Tweets", message: "No Tweets found!", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        tweetsToShow = tweets.sort{($0.dateOfTweet)!.compare($1.dateOfTweet!) == .OrderedDescending}
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() {
            DataManagerAsyc.sharedInstance.getNewTweets({ [weak self] (success, message) in
                if success {
                    if DataManagerAsyc.sharedInstance.newTweets.count > 0 {
                        self?.tweetsToShow.appendContentsOf(DataManagerAsyc.sharedInstance.newTweets)
                        if let tempTweets = self?.tweetsToShow {
                            self?.tweetsToShow = tempTweets.sort{($0.dateOfTweet)!.compare($1.dateOfTweet!) == .OrderedDescending}
                            self?.tweetsTableView.reloadData()
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self?.presentViewController(alertController, animated: true, completion: nil)
                }
                
            })
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDataSource and UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        DataManagerAsyc.sharedInstance.logOut()
        dismissViewControllerAnimated(true, completion: nil)
        
    }

}

