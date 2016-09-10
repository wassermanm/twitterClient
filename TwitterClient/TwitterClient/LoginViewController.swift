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
            //popup alert here
            return
        }
        //
        if let authKey = DataManager.sharedInstance.login(userName, password: password) {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "firstLogin")
            performSegueWithIdentifier("tweetsSegue", sender: nil)
        } else {
            //pop up alert here
        }
        
    }

}

