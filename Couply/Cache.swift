//
//  Cache.swift
//  Couply
//
//  Created by Chenkai Liu on 3/5/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation

private let _cache = Cache()

class Cache: NSObject {
 
    var user : User? {
        didSet {
            if ((user) != nil) {
                NSUserDefaults.standardUserDefaults().setObject(user!.toJsonString(), forKey: Constants.Key.cache_user)
            }
        }
    }
    
    class var sharedInstance : Cache {
        return _cache;
    }
    
    override init() {
        var userString : String? = NSUserDefaults.standardUserDefaults().objectForKey(Constants.Key.cache_user) as! String?
        if (userString != nil) {
            user = User(JSONString: userString!)
        }
    }
    
}