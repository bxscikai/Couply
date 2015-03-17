//
//  emojiManager.swift
//  Couply
//
//  Created by Chenkai Liu on 3/10/15.
//  Copyright (c) 2015 MindVacationInc. All rights reserved.
//

import Foundation
import UIKit

class EmojiManager : NSObject {
    
    static var numberOfEmojis = 10
    
    static func getEmojiImageWithId(emojiId : Int) -> UIImage? {
        if (emojiId > numberOfEmojis) {
            return nil
        }
        return UIImage(named: "\(emojiId)")
    }
    
}