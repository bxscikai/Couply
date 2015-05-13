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
            Constants.Server.query_timestamp : chat.timestamp,
            Constants.Server.query_chatType : chat.chatType.rawValue]
        
        switch chat.chatType
        {
            case ChatType.ChatTypeEmoji:
        
                Alamofire.request(Method.POST, Constants.Server.PostChatsUrl, parameters:queryParameters)
                    .responseJSON { (_, _, JSON, error) in
                        
                        // Error handling
                        let (err, response) = Server.checkForError(JSON as! NSDictionary?, error: error as NSError?)
                        completion(error: err)
                }
                
                break;
            
            case ChatType.ChatTypeAudio:
            
                let urlRequest = Server.urlRequestWithComponents(Constants.Server.PostChatsUrl, parameters: queryParameters, data: NSData(contentsOfFile: chat.filePath as String)!)

                Alamofire.upload(urlRequest.0, urlRequest.1)
                    .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                    }
                    .responseJSON { (request, response, JSON, error) in
                        println("REQUEST \(request)")
                        println("RESPONSE \(response)")
                        println("JSON \(JSON)")
                        println("ERROR \(error)")
                }
                
                break;

            default:
                break;
        }
        
    }
    
    class func fetchInitialData(completion : (error : NSError?) -> Void) {

        let sema = dispatch_semaphore_create(0);
        
        getChats { (chats, error) -> Void in
            println("Returned chats: \(chats) error:\(error)")
            completion(error: error)
            dispatch_semaphore_signal(sema)
        }
    }
    
/////// Utility classes /////////
    
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
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    private class func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, NSObject>, data:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = Constants.Server.boundaryConstant
        let contentType = Constants.Server.contentType
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"\(Constants.Server.audioFileName)\"; filename=\"\(Constants.Server.audioFileName)\(Constants.Server.audioFileExtension)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: \(Constants.Server.mimeTypeAudio)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(data)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
}
