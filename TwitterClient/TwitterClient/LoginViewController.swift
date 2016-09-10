//
//  ViewController.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-09.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userNameField.text = ""
        passwordField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Action Methods
    @IBAction func loginAction(sender: AnyObject) {
        guard let userName = userNameField.text, let password = passwordField.text else {
            //since I'm setting the username and password to empty strings in viewWillAppear 
            //these values will never be nil. This guard statement is here because I believe
            //that forced unwrapping is bad form
            return
        }
        if DataManager.sharedInstance.login(userName, password: password) != nil {
            performSegueWithIdentifier("tweetsSegue", sender: nil)
        } else {
            let alertController = UIAlertController(title: "Invalid Login", message: "You have entered an invalid user name or password. Please try again.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
    }

}

