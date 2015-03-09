//
//  NSError+Common.swift
//  Couply
//
//  Created by Chenkai Liu on 3/9/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation

extension NSError {

    static func errorWithMessage(message : NSString) -> NSError {
        return NSError(domain: Constants.appDomain, code: 400, userInfo: [NSLocalizedDescriptionKey : message])
    }
}