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
    
    override func viewWillAppear(_ animated: Bool) {
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Action Methods
    @IBAction func loginAction(_ sender: AnyObject) {
        guard let userName = userNameField.text, let password = passwordField.text else {
            //since I'm setting the username and password to empty strings in viewWillAppear 
            //these values will never be nil. This guard statement is here because I believe
            //that forced unwrapping is bad form
            return
        }
        
        if Reachability.isNetworkReachable {
            activityIndicator.startAnimating()
            DataManagerAsyc.sharedInstance.login(userName, password: password, completion: { [weak self] (success, message) in
                if success {
                    //get the tweets for the user
                    DataManagerAsyc.sharedInstance.getTweetsForUser({ [weak self] (success, message) in
                        self?.activityIndicator.stopAnimating()
                        self?.performSegue(withIdentifier: "tweetsSegue", sender: self)
                        })
                    
                } else {
                    self?.activityIndicator.stopAnimating()
                    let alertController = UIAlertController(title: "Login Failure", message: "Login has failed. Please try again.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self?.present(alertController, animated: true, completion: nil)
                    return
                }
                })
        } else {
            let alertController = UIAlertController(title: kNetworkErrorTitle, message: kNetworkErrorMessage, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAlertOKButtonTitle, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        
        
        
    }

}

