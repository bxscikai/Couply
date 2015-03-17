//
//  Server.swift
//  Couply
//
//  Created by Chenkai Liu on 3/3/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import UIKit
import Alamofire

class Server: NSObject {

    // Get user
    class func getUser(username : String, completion : (user : User?, error: NSError?) -> Void)
    {
        var queryParameters = [Constants.Server.query_username: username, Constants.Server.query_deviceToken : Cache.sharedInstance.deviceToken]
        println("Get user url: \(Constants.Server.GetUserUrl)")
        
        Alamofire.request(Method.GET, Constants.Server.GetUserUrl, parameters:queryParameters)
                 .responseJSON { (_, _, JSON, error) in

                    // Error handling
                    let (err, response) = Server.checkForError(JSON as! NSDictionary?, error: error as NSError?)
                    if (err != nil) {
                        completion(user:nil, error: err)
                        return
                    }
                    
                    // Returning response
                    var resultUser : User = User(JSONDict: response!.content as! NSDictionary)
                    Cache.sharedInstance.user = resultUser
                    completion(user: resultUser, error: nil)
                    return
        }
    }
    
    // Get chats
    class func getChats(completion : (chats : NSMutableArray?, error : NSError?) ->Void)
    {
        // Ensure we have the user first
        if (Cache.sharedInstance.user == nil) {
            completion(chats: nil, error: NSError.errorWithMessage("No cached user"))
            return
        }
        
        Alamofire.request(Method.GET, Constants.Server.GetChatsUrl, parameters: [Constants.Server.query_username: Cache.sharedInstance.user!.username])
            .responseJSON { (_, _, JSON, error) in
                
                // Error handling
                let (err, response) = Server.checkForError(JSON as! NSDictionary?, error: error as NSError?)
                if (err != nil) {
                    completion(chats:nil, error: err)
                    return
                }
                
                // Returning response
                var chatsDictArray : NSArray = response!.content as! NSArray
                var chats : NSMutableArray = NSMutableArray()
                for chatObj in chatsDictArray
                {
                    if let chat = chatObj as? NSDictionary {
                        chats.addObject(Chat(JSONDict: chat))
                    }
                }
            
                // Sort chats
                Cache.sharedInstance.chats = NSMutableArray(array: Chat.sortChats(chats))
                completion(chats: chats, error: nil)
        }
    }
    
    // Send chat
    class func sendChat(chat : Chat, completion : (error : NSError?) ->Void)
    {
        var queryParameters = [Constants.Server.query_senderName: chat.senderName,
            Constants.Server.query_receiverName : chat.receiverName,
            Constants.Server.query_emojiId : chat.emojiId,
            Constants.Server.query_timestamp : chat.timestamp]
        
        Alamofire.request(Method.POST, Constants.Server.PostChatsUrl, parameters:queryParameters)
            .responseJSON { (_, _, JSON, error) in
                
                // Error handling
                let (err, response) = Server.checkForError(JSON as! NSDictionary?, error: error as NSError?)
                completion(error: err)
        }
    }
    
    class func fetchInitialData(completion : (error : NSError?) -> Void) {

        let sema = dispatch_semaphore_create(0);
        
        getChats { (chats, error) -> Void in
            println("Returned chats: \(chats) error:\(error)")
            completion(error: error)
            dispatch_semaphore_signal(sema)
        }
        
        dispatch_semaphore_wait(sema, 5000)
    }
    
    private class func checkForError(JSONDict : NSDictionary?, error : NSError?) -> (NSError?, response : ResponseWrapper?) {
        if (error != nil) {
            return (error, nil)
        }
        if (JSONDict == nil) {
            return (NSError.errorWithMessage("Return JSON is empty"), nil)
        }
        // Return error if response contains error
        var response = ResponseWrapper(JSONDict: JSONDict! as NSDictionary)
        if (response.error != nil) {
            return(response.error, nil)
        }
        else {
            return (nil, response)
        }
    }
    
}
