//
//  AppDelegate.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import AwesomeCache
import MonkeyKing
import XCGLogger

public func SGLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("\(fileName as NSString)\nmethodName:\(methodName)\nLine:\(lineNumber)\nLog:\(message)");
    #endif
    
}

struct SGGlobalKey {
    static let SCCacheName = "SCCacheName"
    static let SCLoginStatusKey = "SCLoginStatusKey"

    public static let RefreshChatToken = Notification.Name(rawValue: "SlothChat.RefreshChatToken")
    public static let LoginStatusDidChange = Notification.Name(rawValue: "SlothChat.LoginStatusDidChange")
    public static let DiscoveryDataDidChange = Notification.Name(rawValue: "SlothChat.DiscoveryDataDidChange")
}

public enum Position {
    case top, bottom
}

public enum BidAdsType: String {
    case isParticipateAd = "true"
    case notParticipateAd = "false"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let manager = LocationManager()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        addNoticeObserver()
        IQKeyboardManager.sharedManager().enable = true
        manager.startLocationCity()
        ThirdManager.startThirdLib()
        configRemote(application)
        appDefaultConfig()
        
        self.window = UIWindow.init()
        self.changeRootViewController()
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func appDefaultConfig() {
        ItunesCharge.removeFromCache()
        
        if (GVUserDefaults.standard().value(forKey: "networkType") == nil) {
            #if DEBUG
                GVUserDefaults.standard().networkType = .develop
            #else
                GVUserDefaults.standard().networkType = .onLine
            #endif
        }
        
//MARK:社交注册
        MonkeyKing.registerAccount(.weChat(appID: Configs.Wechat.appID, appKey: Configs.Wechat.appKey));
        MonkeyKing.registerAccount(.weibo(appID: Configs.Weibo.appKey, appKey: Configs.Weibo.appSecert, redirectURL: Configs.Weibo.redirectUri))
    }
    
    func addNoticeObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginStatusDidChange), name: SGGlobalKey.LoginStatusDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshChatToken), name: SGGlobalKey.RefreshChatToken, object: nil)
    }
    
    func configRemote(_ application: UIApplication) {
        //推送处理1
        if #available(iOS 8.0, *) {
            //注册推送,用于iOS8以上系统
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: nil))
        } else {
            //注册推送,用于iOS8以下系统
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        }
    }
    
    func LoginStatusDidChange() {
        changeRootViewController()
    }
    
    func changeRootViewController() {
        let logined = Global.shared.isLogin()
        
        if logined {
            ThirdManager.connectRCIM(token: Global.shared.chatToken)
            _ = ChatDataManager.shared
            _ = ChatManager.shared
            
            let rootVC = MainViewController()
            self.window?.rootViewController = rootVC
            ChatDataManager.shared.refreshBadgeValue()
        }else{
            RCIMClient.shared().disconnect(true)

            let rootVC = BaseNavigationController.init(rootViewController: LoginViewController.init())
            rootVC.isNavigationBarHidden = true
//            rootVC.navigationBar.isHidden = true
            self.window?.rootViewController = rootVC
        }
    }
    
    func refreshChatToken() {
        let engine = NetworkEngine()
        engine.getChatToken() { (response) in
            if response?.status == ResponseError.SUCCESS.0{
                if let token = response?.data?.chatToken {
                    Global.shared.chatToken = token
                    ThirdManager.connectRCIM(token: token)
                }
            }
        }
    }
    
    //推送处理2
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //注册推送,用于iOS8以上系统
        application.registerForRemoteNotifications()
    }
    
    //推送处理3
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var rcDevicetoken = deviceToken.description
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: "<", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: ">", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: " ", with: "")
        
        RCIMClient.shared().setDeviceToken(rcDevicetoken)
    }
    
    //推送处理4
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //远程推送的userInfo内容格式请参考官网文档
        //http://www.rongcloud.cn/docs/ios.html#App_接收的消息推送格式
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //本地通知
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

