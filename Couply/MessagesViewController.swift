//
//  MessagesViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    
    override func viewDidLoad() {
        
        fetchUserIfRequired()
        fetchInitialData()
    }
    
    func fetchUserIfRequired() {
        
        // We need to fetch user
        if (Cache.sharedInstance.user == nil) {
            showEnterUsernameDialog()
        }
    }
    
    func showEnterUsernameDialog() {

        // Create new alert
        let alertController = UIAlertController(title: "Load or create user", message: "Please enter your existing or new username", preferredStyle: .Alert)
        
        // Login action: Fetch chats after we get the user name
        let loginAction = UIAlertAction(title: "Set", style: .Default) { (_) in
            let usernameTextField = alertController.textFields![0] as! UITextField
            Server.getUser(usernameTextField.text, completion: { (user, error) -> Void in
                self.fetchInitialData()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }

        // Add text field to alert
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Username"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
        }
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) { () -> Void in }
    }
    
    func fetchInitialData() {

    }

}
