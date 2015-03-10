//
//  MessagesViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit

// MARK: Custom chat cell
class ChatCell : UITableViewCell {
    
    @IBOutlet weak var partnerEmoji: UIImageView!
    @IBOutlet weak var userEmoji: UIImageView!
}

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messagesTable: UITableView!
    
    
    override func viewDidLoad() {
        
        fetchUserIfRequired()
        fetchInitialData()
        setUpUI()
    }
    
    func setUpUI() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "heartPattern")!)
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
        Server.fetchInitialData { (error) -> Void in
            self.messagesTable.reloadData()
        }
    }
    
// MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache.sharedInstance.chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.messagesTable.dequeueReusableCellWithIdentifier(Constants.UIIdentifiers.chatCellIdentifier, forIndexPath: indexPath) as! ChatCell
//        Chat chat = Cache.sharedInstance.chats[indexPath.row]
        
        
        return cell
    }
}
