//
//  AppDelegate.swift
//  SlothChat
//
//  Created by 王一丁 on 2016/10/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import AwesomeCache

public func SGLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DEBUG
        print("\(fileName as NSString)\nmethodName:\(methodName)\nLine:\(lineNumber)\nLog:\(message)");
    #endif
}

struct SGGlobalKey {
    static let SCCacheName = "SCCacheName"
    static let SCLoginStatusKey = "SCLoginStatusKey"

    public static let LoginStatusDidChange = Notification.Name(rawValue: "SlothChat.LoginStatusDidChange")

}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        NSObject.registerShareSDK()
        NBSAppAgent.start(withAppID: "9618217e76524a188e49ef32475489ac")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginStatusDidChange), name: SGGlobalKey.LoginStatusDidChange, object: nil)
        
        self.window = UIWindow.init()
        self.changeRootViewController()
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func LoginStatusDidChange() {
        changeRootViewController()
    }
    
    func changeRootViewController() {
        let logined = Global.shared.isLogin()
        
        if logined {
            let rootVC = MainViewController()
            self.window?.rootViewController = rootVC
        }else{
            let rootVC = BaseNavigationController.init(rootViewController: LoginViewController.init())
            rootVC.navigationBar.isHidden = true
            self.window?.rootViewController = rootVC
        }
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

