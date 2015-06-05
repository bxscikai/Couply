//
//  Constant.swift
//  Couply
//
//  Created by Chenkai Liu on 3/3/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation

struct Constants {
    
    static var appDomain = "Couply"
    static let numberOfEmojis = 17
    static let recordIconIndex = 0
    
    // Server related constant
    struct Server {
        
        // URLs
        static let LOCAL_DEBUGGING = true
        static let LocalBaseUrl = "http://localhost:3000/"
        static var BaseUrl = "http://6587801d.ngrok.com/"
        static let dynamicIPUrl = "http://minetteyu.com/files/couplyIP.txt"

        static let Users = "users/"
        static let Chats = "chats/"
        static let GetUserUrl = Constants.Server.BaseUrl + Constants.Server.Users + "get/"
        static let RequestPartnerUrl = Constants.Server.BaseUrl + Constants.Server.Users + "setPartner/"
        static let ApprovePartnerUrl = Constants.Server.BaseUrl + Constants.Server.Users + "approvePartner/"
        static let RemovePartnerUrl = Constants.Server.BaseUrl + Constants.Server.Users + "removePartner/"
        static let GetChatsUrl = Constants.Server.BaseUrl + Constants.Server.Chats + "get/"
        static let PostChatsUrl = Constants.Server.BaseUrl + Constants.Server.Chats + "set/"
        
        // Post constants
        static let boundaryConstant = "---Boundary4923874---"
        static let contentType = "multipart/form-data;boundary=" + Constants.Server.boundaryConstant
        static let mimeTypeAudio = "audio/vnd.wave"
        static let audioFileName = "audioFile"
        static let audioFileExtension = ".wav"
        
        // Query keys
        static let query_username = "username"
        static let query_partnerName = "partnerName"
        static let query_deviceToken = "deviceToken"
        static let query_senderName = "senderName"
        static let query_receiverName = "receiverName"
        static let query_timestamp = "timestamp"
        static let query_emojiId = "emojiId"
        static let query_chatType = "chatType"
    }
    
    struct Key {
        static let cache_user = "userkey"
    }
    
    struct Notification {
        static let pushnotification_key = "pushnotificationKey"
        static let audioFinishedRecording_key = "audioFinishedRecording"
    }
    
    struct error {
        struct code {
            
        }
        struct message {
        
        }
    }
    
    struct UIIdentifiers {
        static let chatCellIdentifier = "chatCell"
        static let emojiCollectionCellIdentifier = "emojiCollectionCell"
    }
    
}