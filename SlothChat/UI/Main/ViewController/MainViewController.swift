//
//  MainViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getSystemConfig()
        
        let discoveryNav = BaseNavigationController(rootViewController: DiscoveryViewController())
        
        let chatNav = BaseNavigationController(rootViewController:SCConversationListViewController())
        
        let meVC = UserInfoViewController()
        meVC.isMyselfFlag = true
        meVC.mUserUuid = Global.shared.globalProfile?.userUuid
        
        let meNav = BaseNavigationController(rootViewController:meVC)
        
        self.viewControllers = [discoveryNav,chatNav,meNav]
        
        UINavigationBar.appearance()
        //设置tabbar的选择颜色
//        UITabBar.appearance().tintColor = UIColor.redColor(, 0, 0);
        
        //设置tabbar的不同按钮的显示方式,这里通过tabBar的属性items来获取不同的UITabBarItem,且对应到主面板的排列顺序.
        let firstbar =  self.tabBar.items![0] ;
        firstbar.image = UIImage(named: "discover-gray")?.withRenderingMode(.alwaysOriginal)
        firstbar.selectedImage = UIImage(named: "discover-champagne")?.withRenderingMode(.alwaysOriginal)
        firstbar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        
        let secondbar = self.tabBar.items![1];
        
        secondbar.image = UIImage(named: "chat-gray")?.withRenderingMode(.alwaysOriginal)
        secondbar.selectedImage = UIImage(named: "chat-champagne")?.withRenderingMode(.alwaysOriginal)
        secondbar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)

        let thirdbar = self.tabBar.items![2];
        
        thirdbar.image = UIImage(named: "me-gray")?.withRenderingMode(.alwaysOriginal)
        thirdbar.selectedImage = UIImage(named: "me-champagne")?.withRenderingMode(.alwaysOriginal)
        thirdbar.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    
    
    //MARK:- NetWork
    
    func getSystemConfig()  {
        let engine = NetworkEngine()
        engine.getSysConfig { (config) in
            if config?.status == ResponseError.SUCCESS.0 {
                Global.shared.globalSysConfig = config?.data
            }else{
                SGLog(message: "获取系统配置失败")
            }
        }
    }
}
