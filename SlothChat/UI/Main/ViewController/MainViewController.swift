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
        
        let discoveryNav = UINavigationController(rootViewController: DiscoveryViewController())
        let chatNav = UINavigationController(rootViewController:ChatViewController())
        let meNav = UINavigationController(rootViewController:MeViewController())
        
        self.viewControllers = [discoveryNav,chatNav,meNav]
        
        UINavigationBar.appearance()
        //设置tabbar的选择颜色
//        UITabBar.appearance().tintColor = UIColor.redColor(, 0, 0);
        
        //设置tabbar的不同按钮的显示方式,这里通过tabBar的属性items来获取不同的UITabBarItem,且对应到主面板的排列顺序.
        let firstbar =  self.tabBar.items![0] ;
        firstbar.title = "探";
        firstbar.image = UIImage(named: "discover-gray")
        firstbar.selectedImage = UIImage(named: "discover-champagne")
        
        let secondbar = self.tabBar.items![1];
        
        secondbar.title = "聊"
        secondbar.image = UIImage(named: "chat-gray")
        secondbar.selectedImage = UIImage(named: "chat-champagne")
        
        let thirdbar = self.tabBar.items![2];
        
        thirdbar.title = "我"
        thirdbar.image = UIImage(named: "add-group-black")
        thirdbar.selectedImage = UIImage(named: "add-group-champagne")
    }

}
