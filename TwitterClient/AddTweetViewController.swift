//
//  AddTweetViewController.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import UIKit

class AddTweetViewController: UIViewController, UITextViewDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var newTweetTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newTweetTextView.layer.borderWidth = 2.0
        self.newTweetTextView.layer.borderColor = UIColor.gray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction Methods
    @IBAction func dismissNewTweetAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweetAction(_ sender: AnyObject) {
        if Reachability.isNetworkReachable {
            self.activityIndicator.startAnimating()
            DataManagerAsyc.sharedInstance.addTweet(newTweetTextView.text, completion: { [weak self] (success, error) in
                if success {
                    self?.activityIndicator.stopAnimating()
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Tweet Error", message: "An error occurred. Your tweet was not saved. Please try again later.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                    self?.activityIndicator.stopAnimating()
                    self?.dismiss(animated: true, completion: nil)
                }
            })
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UITextViewDelegate Methods
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !(textView.text.characters.count + (text.characters.count - range.length) <= 140) {
            //input for tweet exceeds 140 characters - inform user
            let alertController = UIAlertController(title: "Limit Exceeded", message: "Your tweet exceeds 140 characters", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

}
