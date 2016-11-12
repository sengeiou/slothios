//
//  ChatManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ChatManager: NSObject {
    
    var friendArray = [RCUserInfo]()
    
    
    static var shared : ChatManager {
        struct Static {
            static let instance : ChatManager = ChatManager()
        }
        return Static.instance
    }
}
