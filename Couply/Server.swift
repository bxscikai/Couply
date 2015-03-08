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

    class func getUser(username : String) {
        
        println("Sending GET request to \(Constants.Server.GetUserUrl)")
        Alamofire.request(Method.GET, Constants.Server.GetUserUrl, parameters: [Constants.Server.query_username: username])
                 .responseJSON { (_, _, JSON, _) in
                    println(JSON)
        }
    }
    
    class   func getCurrentUser() {
        
    }
    
}
