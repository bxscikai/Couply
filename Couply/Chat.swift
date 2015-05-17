//
//  Chat.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation

class Chat: Serializable {
    
    var senderName : NSString = ""
    var receiverName : NSString = ""
    var chatType : ChatType = ChatType.ChatTypeUnknown
    var filePath : NSString = ""
    var emojiId : NSNumber = 0
    var timestamp : NSNumber = 0
    
    convenience init(emojiIdSending : NSNumber) {
        self.init()
        self.emojiId = emojiIdSending
        self.receiverName = Cache.sharedInstance.user!.partnerName
        self.senderName = Cache.sharedInstance.user!.username
        self.chatType = ChatType.ChatTypeEmoji
        self.timestamp = NSDate().timeIntervalSince1970
    }
    
    convenience init(audioFileSending : NSString) {
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
