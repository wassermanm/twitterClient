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
        if Reachability.isNetworkReachable {
            tweets = DataManagerAsyc.sharedInstance.tweets
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        if tweets.count < 1 {
            let alertController = UIAlertController(title: "No Tweets", message: "No Tweets found!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        tweetsToShow = tweets.sorted{($0.dateOfTweet)!.compare($1.dateOfTweet! as Date) == .orderedDescending}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isNetworkReachable {
            DataManagerAsyc.sharedInstance.getNewTweets({ [weak self] (success, message) in
                if success {
                    if DataManagerAsyc.sharedInstance.newTweets.count > 0 {
                        self?.tweetsToShow.append(contentsOf: DataManagerAsyc.sharedInstance.newTweets)
                        if let tempTweets = self?.tweetsToShow {
                            self?.tweetsToShow = tempTweets.sorted{($0.dateOfTweet)!.compare($1.dateOfTweet!) == .orderedDescending}
                            self?.tweetsTableView.reloadData()
                        }
                    }
                } else {
                    let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
                
            })
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITableViewDataSource and UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetCell
        cell.render(tweetsToShow[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    //MARK: - IBAction Methods
    @IBAction func logoutAction(_ sender: AnyObject) {
        DataManagerAsyc.sharedInstance.logOut()
        dismiss(animated: true, completion: nil)
        
    }

}

