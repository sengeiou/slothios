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
        self.syncGroupList { (userList) in
            
        }
        self.syncChatList { (chatList) in
            
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
//        ChatManager.shared.friendArray.removeAll()
//        let user1202 = RCUserInfo(userId: "18667931202", name: "1202", portrait: "https://tower.im/assets/default_avatars/path.jpg")
//        let user1203 = RCUserInfo(userId: "18667931203", name: "1203", portrait: "https://tower.im/assets/default_avatars/jokul.jpg")
//        let userList = [user1202!,user1203!]
//        ChatManager.shared.friendArray = userList
//        completion(userList)
    }
    
    func syncChatList(completion: (([RCUserInfo]?) -> Void)!) {
        let engine = NetworkEngine()
        engine.getChatList() { (response) in
            if response?.status == ResponseError.SUCCESS.0{
                
            }
        }
    }
    
    func syncGroupList(completion: (([RCGroup]?) -> Void)!) {
        ChatManager.shared.groupArray.removeAll()
        let group = RCGroup(groupId: "1", groupName: "北美官方群", portraitUri: "http://farm2.staticflickr.com/1709/24157242566_98d0192315_m.jpg")
        let groupList = [group!]
        ChatManager.shared.groupArray = groupList
        completion(groupList)
    }
    
    class func userInfoWidthID(_ userUuid: String,completion: ((RCUserInfo?) -> Void)!){
        let friendArray = ChatManager.shared.friendArray
        
        if userUuid.isEmpty {
            return
        }
        
        for tmpUserInfo in friendArray {
            if userUuid == tmpUserInfo.userId {
                completion(tmpUserInfo)
                return
            }
        }
        let engine = NetworkEngine()
        engine.getUserProfile(userUuid: userUuid) { (profile) in
            if profile?.status == ResponseError.SUCCESS.0 {
                if (profile?.data) != nil{
                    let userInfo = RCUserInfo()
                    userInfo.name = profile?.data?.nickname
                    userInfo.portraitUri = profile?.data?.userPhotoList?.first?.profileBigPicUrl
                    userInfo.userId = profile?.data?.userUuid
                    ChatManager.shared.friendArray.append(userInfo)
                    RCIM.shared().refreshUserInfoCache(userInfo, withUserId: userUuid)

                    completion(userInfo)
                }
            }
        }
    }
    
    class func groupInfoWidthID(_ groupId: String) -> RCGroup?{
        let groupArray = ChatManager.shared.groupArray
        
        if groupId.isEmpty || groupArray.count <= 0 {
            return nil
        }
        for tmpGroup in groupArray {
            if groupId == tmpGroup.groupId {
                return tmpGroup
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
        ChatDataManager.userInfoWidthID(userId){ (userInfo) in
            completion(userInfo)
        }
    }
    
    public func refreshBadgeValue(){
        DispatchQueue.main.async {
            let types = [RCConversationType.ConversationType_PRIVATE.rawValue,
                         RCConversationType.ConversationType_DISCUSSION.rawValue,
                         RCConversationType.ConversationType_GROUP.rawValue,
                         RCConversationType.ConversationType_CHATROOM.rawValue]
            let unreadMsgCount = RCIMClient.shared().getUnreadCount(types)
            
            let tmpApp = UIApplication.shared.delegate as! AppDelegate;
            if let mainVC = tmpApp.window?.rootViewController as? UITabBarController{
                let chatNav = mainVC.viewControllers?[1]
                
                chatNav?.showTabBadgePoint = (unreadMsgCount > 0)
            }

        }
    }
    
    
    public func isExistFriend(userId: String) -> Bool{
//        let userInfo = ChatDataManager.userInfoWidthID(userId)
//        if userInfo == nil {
//            return false
//        }
        return true
    }
}
