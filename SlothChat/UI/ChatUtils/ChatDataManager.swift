//
//  ChatDataManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/12.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ChatDataManager: NSObject,RCIMUserInfoDataSource {

    override init() {
        super.init()
        self.syncFriendList { (userList) in
            
        }
        RCIM.shared().userInfoDataSource = self
    }
    
    static var shared : ChatDataManager {
        struct Static {
            static let instance : ChatDataManager = ChatDataManager()
        }
        return Static.instance
    }
    
    func syncFriendList(completion: (([RCUserInfo]?) -> Void)!) {
        let user1202 = RCUserInfo(userId: "18667931202", name: "1202", portrait: "https://tower.im/assets/default_avatars/path.jpg")
        let user1203 = RCUserInfo(userId: "18667931203", name: "1203", portrait: "https://tower.im/assets/default_avatars/jokul.jpg")
        let userList = [user1202!,user1203!]
        ChatManager.shared.friendArray = userList
        completion(userList)
    }
    
    class func userInfoWidthID(_ userId: String) -> RCUserInfo?{
        let friendArray = ChatManager.shared.friendArray
        
        if userId.isEmpty || friendArray.count <= 0 {
            return nil
        }
        for tmpUserInfo in friendArray {
            if userId == tmpUserInfo.userId {
                return tmpUserInfo
            }
        }
        return nil
    }
    
    
//    -(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion

    
    /*!
     获取用户信息
     
     @param userId      用户ID
     @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
     
     @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
     在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
     */
    public func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        let userInfo = ChatDataManager.userInfoWidthID(userId)
        completion(userInfo)
    }
}
