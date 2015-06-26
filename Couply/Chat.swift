//
//  Chat.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation
import Alamofire

class Chat: Serializable {
    
    var senderName : NSString = ""
    var receiverName : NSString = ""
    var chatType : ChatType = ChatType.ChatTypeUnknown
    var filePath : NSURL = NSURL()
    var emojiId : NSNumber = 0
    var timestamp : NSNumber = 0
    
    override init() {
        super.init()
    }
    
    override init(JSONDict: NSDictionary) {
        super.init(JSONDict: JSONDict)
        self.downloadAudioIfRequired()
    }
    
    convenience init(emojiIdSending : NSNumber) {
        self.init()
        self.emojiId = emojiIdSending
        self.receiverName = Cache.sharedInstance.user!.partnerName
        self.senderName = Cache.sharedInstance.user!.username
        self.chatType = ChatType.ChatTypeEmoji
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    convenience init(audioFileSending : NSURL) {
        self.init()
        self.receiverName = Cache.sharedInstance.user!.partnerName
        self.senderName = Cache.sharedInstance.user!.username
        self.chatType = ChatType.ChatTypeAudio
        self.filePath = audioFileSending
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    convenience init(emojiIdReceiving : NSNumber, timestamp : NSNumber) {
        self.init()
        self.emojiId = emojiIdReceiving
        self.receiverName = Cache.sharedInstance.user!.username
        self.senderName = Cache.sharedInstance.user!.partnerName
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    func downloadAudioIfRequired() -> Void
    {
        // This is an audio emoji
        if (self.emojiId == Constants.audioEmojiId)
        {
            var fileDownloadUrl : String = Constants.Server.BaseUrl + self.timestamp.description
            let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
            
            Alamofire.download(Method.GET, fileDownloadUrl, { (temporaryURL, response) -> (NSURL) in
                
                var directoryURL : NSURL? = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL
                directoryURL =  directoryURL!.URLByAppendingPathComponent(Constants.path.audioFilePath)
                
                self.createDirectoryIfRequired(Constants.path.audioFilePath)
                
                let pathComponent = response.suggestedFilename
                let fileURL =  directoryURL!.URLByAppendingPathComponent(pathComponent!)
                self.filePath = fileURL
                return fileURL
                
            }).response { (_, _, data, err) -> Void in
                
            }
        }
    }
    
    func createDirectoryIfRequired(dir : String) -> Void
    {
        var error: NSError?
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentsDirectory: AnyObject = paths[0]
        var dataPath = documentsDirectory.stringByAppendingPathComponent(Constants.path.audioFilePath)
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            NSFileManager.defaultManager() .createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
    }
    
    
    static func sortChats(chats : NSArray) -> NSArray
    {
        var sortedChats : NSArray = chats.sortedArrayUsingComparator {
            (obj1, obj2) -> NSComparisonResult in
            let chat1 = obj1 as! Chat
            let chat2 = obj2 as! Chat
            let result = chat1.timestamp.compare(chat2.timestamp)
            return result
        }
        return sortedChats
    }
    
}
