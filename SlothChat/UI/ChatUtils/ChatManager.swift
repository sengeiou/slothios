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
    var groupArray = [RCGroup]()

    
    static var shared : ChatManager {
        struct Static {
            static let instance : ChatManager = ChatManager()
        }
        return Static.instance
    }
    
    func refreshUserInfo(userInfo: UserProfileData) {
        guard let userUuid = userInfo.userUuid  else {
            return
        }
        
        var isNotExist = true
        
        for friend in friendArray {
            if friend.userId == userUuid {
                isNotExist = false
                configUserInfo(friend: friend, userInfo: userInfo)
                return
            }
        }
        
        if isNotExist {
            let friend = RCUserInfo()
            configUserInfo(friend: friend, userInfo: userInfo)
            self.friendArray.append(friend)
        }
    }
    
    func configUserInfo(friend: RCUserInfo, userInfo: UserProfileData) {
        friend.name = userInfo.nickname
        friend.portraitUri = userInfo.userPhotoList?.first?.profileBigPicUrl
        friend.userId = userInfo.userUuid
    }
}
