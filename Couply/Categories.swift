//
//  Categories.swift
//  Couply
//
//  Created by Chenkai Liu on 6/28/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation
import UIKit

func stringFromBool(boolValue : Bool) -> String
{
    if (boolValue) {
        return "true"
    }
    else {
        return "false"
    }
}

extension UIViewController
{
    func showAlert(title : String, message: String, okayString: String)
    {
        // Create new alert
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: okayString, style: .Cancel) { (_) in }

        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true) { () -> Void in }        
    }
}