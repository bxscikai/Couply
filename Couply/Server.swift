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

    class func getUser(username : String, completion : (user : User?, error: NSError?) -> Void) {
        
        Alamofire.request(Method.GET, Constants.Server.GetUserUrl, parameters: [Constants.Server.query_username: username])
                 .responseJSON { (_, _, JSON, error) in

                    var err = Server.checkForError(JSON as! NSDictionary?, error: error as NSError?)
                    if (err != nil) {
                        completion(user:nil, error: err)
                    }
                    else {
                        var response = ResponseWrapper(JSONDict: JSON as! NSDictionary)
                        var resultUser : User = User(JSONDict: response.content)
                        Cache.sharedInstance.user = resultUser
                        completion(user: resultUser, error: nil)
                    }
        }
    }
    
    class func fetchInitialData(completion : (error : NSError?) -> Void) {

    }
    
    private class func checkForError(JSONDict : NSDictionary?, error : NSError?) -> NSError? {
        if (error != nil) {
            return error
        }
        else if (JSONDict == nil) {
            var err = NSError(domain: Constants.appDomain,
                                code: 400,
                            userInfo:[NSLocalizedDescriptionKey : "Return JSON is empty"])
            return err
        }
        return nil
    }
    
}
