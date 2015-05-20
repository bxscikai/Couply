//
//  MessagesViewController.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: Custom chat cell
class ChatCell : UITableViewCell {
    
    @IBOutlet weak var partnerEmoji: UIImageView!
    @IBOutlet weak var userEmoji: UIImageView!
}

class ChatEmojiCollection : UICollectionViewCell {
    
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var emojiButton: UIButton!
}

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var messagesTable: UITableView!
    @IBOutlet weak var emojiCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        // Register for notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedRemoteNotfication:", name:Constants.Notification.pushnotification_key, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "audioRecordingComplete:", name:Constants.Notification.audioFinishedRecording_key, object: nil)
        
        fetchUserIfRequired()
        fetchInitialData()
        setUpUI()
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
        scrollToBottom()
    }
    
    func setUpUI() {
        self.messagesTable.backgroundColor = UIColor(patternImage: UIImage(named: "messageBackground")!)
        self.emojiCollectionView.backgroundColor = UIColor(patternImage: UIImage(named: "emojiBackground")!)
        if (Cache.sharedInstance.user != nil)
        {
            self.title = Cache.sharedInstance.user!.partnerName
        }
    }
    
    func scrollToBottom() {
        // Start tableview scrolled all the way to the bottom
        if (Cache.sharedInstance.chats.count > 0)
        {
            var indexPath : NSIndexPath = NSIndexPath(forRow: Cache.sharedInstance.chats.count - 1, inSection: 0)
            self.messagesTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
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
            let username = usernameTextField.text
            Server.getUser(username, completion: { (user, error) -> Void in
                
                // If we failed to get user, something is wrong, bail
                if (Cache.sharedInstance.user == nil) {
                    
                    let failedToFetchUserError = UIAlertController(title: "Failed to load user", message: "Failed to load user from Database, the backend is likely not responding", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Okay", style: .Cancel) { (_) in }

                    failedToFetchUserError.addAction(cancelAction)
                    
                    self.presentViewController(failedToFetchUserError, animated: true, completion: {})
                    return;
                }
                
                self.title = Cache.sharedInstance.user!.partnerName
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
            self.scrollToBottom()
        }
    }
    
    func receivedRemoteNotfication(notification: NSNotification){
        if (notification.object != nil) {
            var chat : Chat = notification.object as! Chat
            Cache.sharedInstance.addChat(chat)
            self.messagesTable.reloadData()
            self.scrollToBottom()
        }
    }
    
    func audioRecordingComplete(notification: NSNotification){
        if (notification.object != nil) {
            var audio : RecordedAudio = notification.object as! RecordedAudio
            AudioManager.sharedInstance.playSound(audio.filePathUrl)
            
            // Send audio to server
            var chat : Chat = Chat(audioFileSending: audio.filePathUrl!)
            Server.sendChat(chat, completion: { (error) -> Void in
                println("Error when sending audio chat: \(error)")
            })
            
        }
    }
    
// MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache.sharedInstance.chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.messagesTable.dequeueReusableCellWithIdentifier(Constants.UIIdentifiers.chatCellIdentifier, forIndexPath: indexPath) as! ChatCell
        var chat : Chat = Cache.sharedInstance.chats[indexPath.row] as! Chat
        var emoji : UIImage = EmojiManager.getEmojiImageWithId(chat.emojiId.integerValue)!
        
        if (chat.senderName == Cache.sharedInstance.user!.username) {
            cell.userEmoji.image = emoji
            cell.partnerEmoji.image = nil
        }
        else {
            cell.partnerEmoji.image = emoji
            cell.userEmoji.image = nil
        }

        return cell
    }
    
// MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.UIIdentifiers.emojiCollectionCellIdentifier, forIndexPath: indexPath) as! ChatEmojiCollection
        cell.emojiButton.tag = indexPath.row
        cell.emojiButton.setImage(EmojiManager.getEmojiImageWithId(indexPath.row), forState: UIControlState.Normal)
        
        // Set image size on collection view
        if (indexPath.row == Constants.recordIconIndex)
        {
            cell.buttonHeight.constant = 50;
            cell.buttonWidth.constant = 50;
        }
        else
        {
            cell.emojiButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return Constants.numberOfEmojis
    }
    
    // Emoji Pressed
    @IBAction func emojiPressed(sender: AnyObject)
    {
        var button : UIButton = sender as! UIButton
        println("Pressed emoji up: \(button.tag)")
        
        // If this button is to record audio
        if (button.tag == Constants.recordIconIndex)
        {
            // Record is not recording, or stop if already recording
            if (AudioManager.sharedInstance.audioRecorder != nil && AudioManager.sharedInstance.audioRecorder.recording)
            {
                AudioManager.sharedInstance.stopRecording()
                button.layer.removeAllAnimations()
            }
            else
            {
                AudioManager.sharedInstance.startRecording()
                // Add fade in out animation
                var fadeAnimation = CABasicAnimation(keyPath: "opacity")
                fadeAnimation.fromValue = 0.0
                fadeAnimation.toValue = 1.0
                fadeAnimation.duration = 1.5
                fadeAnimation.autoreverses = true
                fadeAnimation.repeatCount = Float.infinity
                button.layer.addAnimation(fadeAnimation, forKey: "opacity")
            }
            return
        }
        
        // Else this is a regular emoji button
        else
        {
            var chat : Chat = Chat.init(emojiIdSending:button.tag)
            
            Server.sendChat(chat, completion: { (error) -> Void in
                if (error != nil) {
                    println("Error when sending chat: \(error)")
                }
                else
                {
                    Cache.sharedInstance.addChat(chat)
                    self.messagesTable.reloadData()
                    self.scrollToBottom()
                }
                
                })
        }
    }
}
