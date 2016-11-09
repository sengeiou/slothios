//
//  ThirdManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit


class ThirdManager: NSObject,RCIMUserInfoDataSource {
    
    override init() {
        super.init()
        RCIM.shared().userInfoDataSource = self
    }
    
    
    class func startThirdLib() {
        startNBSAppAgent()
        startRongCloudIM()
        NSObject.registerShareSDK()
    }
    
    fileprivate class func startNBSAppAgent() {
        NBSAppAgent.start(withAppID: "9618217e76524a188e49ef32475489ac")
    }
    
    fileprivate class func startRongCloudIM() {
        RCIM.shared().initWithAppKey("8w7jv4qb7e8sy")
        let token1202 = "11WqtSIFDg729Iat6IEfaixnj5P1WqmmscqozTd4ISYbwe9bdrgn6g3vvRXHhJOmsuqlzhfTj0UUduiuoBPkW1/Ze0P+2i2s"
        let token1203 = "4KLwxM4JJr2D1UYxaYpb9Sxnj5P1WqmmscqozTd4ISYbwe9bdrgn6qNlwcT73VMymLgy9GP8oXkUduiuoBPkWzPsRPtDXGOw"

        RCIM.shared().globalConversationAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE

        connectRCIM(token: token1203)
        
    }
    
    class func connectRCIM(token: String) {
        RCIM.shared().connect(withToken: token, success: { (userId : String?) -> Void in
            print("登陆成功。当前登录的用户ID：\(userId)")
        }, error: { (status) -> Void in
            print("登陆的错误码为:\(status.rawValue)")
        }, tokenIncorrect: { () -> Void in
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            print("token错误")
            
        })
    }
    
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        if userId == "18667931202" {
            let user = RCUserInfo(userId: userId, name: "1202", portrait: "https://tower.im/assets/default_avatars/path.jpg")
            return completion(user)
        }else if userId == "18667931203" {
            let user = RCUserInfo(userId: userId, name: "1203", portrait: "https://tower.im/assets/default_avatars/jokul.jpg")
            return completion(user)
        }
        return completion(nil)
    }
}
