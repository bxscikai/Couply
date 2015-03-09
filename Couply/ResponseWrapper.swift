//
//  ResponseWrapper.swift
//  Couply
//
//  Created by Chenkai Liu on 3/8/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation

class ResponseWrapper: Serializable {
    var status : String = ""
    var message : String = ""
    var content : NSDictionary = [:]
    
    override init(JSONDict: NSDictionary) {
        super.init(JSONDict: JSONDict)
        
    }
}
