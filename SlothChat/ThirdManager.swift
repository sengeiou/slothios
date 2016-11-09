//
//  ThirdManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit


class ThirdManager: NSObject {
    
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
        let token = ""
        
//        RCIM.shared().connectWithToken("YourTestUserToken",
//                                           success: { (userId) -> Void in
//                                            print("登陆成功。当前登录的用户ID：\(userId)")
//        }, error: { (status) -> Void in
//            print("登陆的错误码为:\(status.rawValue)")
//        }, tokenIncorrect: {
//            //token过期或者不正确。
//            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//            print("token错误")
//        })
    }
}
