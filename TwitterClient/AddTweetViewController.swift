//
//  AddTweetViewController.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import UIKit

class AddTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var newTweetTextView: UITextView!
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newTweetTextView.layer.borderWidth = 2.0
        self.newTweetTextView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - IBAction Methods
    @IBAction func dismissNewTweetAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tweetAction(sender: AnyObject) {
    }
    
    //MARK: - UITextViewDelegate Methods
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if !(textView.text.characters.count + (text.characters.count - range.length) <= 140) {
            //input for tweet exceeds 140 characters - inform user
            let alertController = UIAlertController(title: "Limit Exceeded", message: "Your tweet exceeds 140 characters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

}
