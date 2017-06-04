//
//  ThirdManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit


class ThirdManager: NSObject {
    
    override init() {
        super.init()
    }
    
    class func startThirdLib() {
        
        startRongCloudIM()
    }
    
    fileprivate class func startRongCloudIM() {
        #if DEBUG
            //RCIM.shared().initWithAppKey("8w7jv4qb7e8sy")
            RCIM.shared().initWithAppKey("82hegw5uhf8zx")
        #else
            RCIM.shared().initWithAppKey("82hegw5uhf8zx")
        #endif
        RCIM.shared().enableMessageRecall = true
        RCIM.shared().globalConversationAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        RCIM.shared().globalMessageAvatarStyle = RCUserAvatarStyle.USER_AVATAR_CYCLE
        RCIM.shared().globalNavigationBarTintColor = SGColor.black
    }
    
    class func connectRCIM(token: String?) {
        if !Global.shared.isLogin(){
            return
        }
        guard let token = token else {
            SGLog(message: "chatToken 为空")

            return
        }
        
        RCIM.shared().connect(withToken: token, success: { (userId : String?) -> Void in
            SGLog(message: "登陆成功。当前登录的用户ID：\(String(describing: userId))")
        }, error: { (status) -> Void in
            SGLog(message: "登陆的错误码为:\(status.rawValue)")
        }, tokenIncorrect: { () -> Void in
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NotificationCenter.default.post(name: SGGlobalKey.RefreshChatToken, object: nil)
            SGLog(message: "token错误")
        })
    }
}
