//
//  UIViewController+Extension.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension UIViewController{
    
    func setNavtionBack(titleStr: String?) {
        if titleStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(title: titleStr, style: .plain, target: self, action: #selector(backClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setNavtionBack(imageStr: String?) {
        if imageStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr!), style: .plain, target: self, action: #selector(backClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setNavtionConfirm(titleStr: String?) {
        if titleStr == nil {
            return
        }
        let barItem = UIBarButtonItem.init(title: titleStr, style: .plain, target: self, action: #selector(confirmClick))
        barItem.tintColor = UIColor.black
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setNavtionConfirm(imageStr: String?) {
        if imageStr == nil {
            return
        }
        if let imageStr = imageStr {
            let barItem = UIBarButtonItem.init(image: UIImage.init(named: imageStr), style: .plain, target: self, action: #selector(confirmClick))
            self.navigationItem.rightBarButtonItem = barItem
        }
    }
    
    func showNotificationError(message: String?) {
        guard let message = message else {
            CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: "操作失败~", duration: 2)
            return
        }
        CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
    }
    
    func showNotificationSuccess(message: String?) {
        guard let message = message else {
            CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: "操作成功!", duration: 2)
            return
        }
        CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
    }
    
    class func showCurrentViewControllerNotificationError(message: String?) {
        let tmpApp = UIApplication.shared.delegate as! AppDelegate;
        let rootVC = tmpApp.window?.rootViewController
        if (rootVC?.isKind(of: UITabBarController.self))! {
            let tabbarVC = rootVC as! UITabBarController
            let selectedNav = tabbarVC.viewControllers?[tabbarVC.selectedIndex]
            if (selectedNav?.isKind(of: UINavigationController.self))! {
                let nav = selectedNav as! UINavigationController
                let activityVC = nav.viewControllers.last
                CSNotificationView.show(in: activityVC, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
            }else if (selectedNav?.isKind(of: UIViewController.self))! {
                CSNotificationView.show(in: selectedNav, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
            }

        }else if (rootVC?.isKind(of: UINavigationController.self))! {
            let nav = rootVC as! UINavigationController
            let activityVC = nav.viewControllers.last
            CSNotificationView.show(in: activityVC, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
            
        }else if (rootVC?.isKind(of: UIViewController.self))! {
            CSNotificationView.show(in: rootVC, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message, duration: 2)
        }
    }
    
    func backClick() {
        SGLog(message: "")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func confirmClick() {
        SGLog(message: "")
    }
}
