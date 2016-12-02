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
            UIViewController.showNotification(message: "操作失败~", viewController: self)
            return
        }
        UIViewController.showNotification(message: message, viewController: self)
    }
    
    func showNotificationSuccess(message: String?) {
        guard let message = message else {
            UIViewController.showNotification(message: "操作成功!", viewController: self)
            return
        }
        UIViewController.showNotification(message: message, viewController: self)
    }
    
    func showNotificationProgress(message: String?) -> CSNotificationView {
        guard let message = message else {
            let noteView =  CSNotificationView(parentViewController: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: "操作成功!")
            noteView?.setNoteAlpha(0.7)
            noteView?.isShowingActivity = true
            noteView?.setVisible(true, animated: true, completion: nil)
            return noteView!
        }
        let noteView =  CSNotificationView(parentViewController: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message)
        noteView?.setNoteAlpha(0.7)
        noteView?.isShowingActivity = true
        noteView?.setVisible(true, animated: true, completion: nil)
        return noteView!
    }
    
    func hiddenNotificationProgress(noteView: CSNotificationView) {
        
        noteView.setVisible(false, animated: false, completion: nil)
    }
    
    class func showCurrentViewControllerNotificationError(message: String?) {
        var tmpMessage = "操作失败"
        if message != nil {
            tmpMessage = message!
        }
        let tmpApp = UIApplication.shared.delegate as! AppDelegate;
        let rootVC = tmpApp.window?.rootViewController
        if (rootVC?.isKind(of: UITabBarController.self))! {
            let tabbarVC = rootVC as! UITabBarController
            let selectedNav = tabbarVC.viewControllers?[tabbarVC.selectedIndex]
            if (selectedNav?.isKind(of: UINavigationController.self))! {
                let nav = selectedNav as! UINavigationController
                let activityVC = nav.viewControllers.last
                showNotification(message: tmpMessage, viewController: activityVC!)
            }else if (selectedNav?.isKind(of: UIViewController.self))! {
                showNotification(message: tmpMessage, viewController: selectedNav!)
            }

        }else if (rootVC?.isKind(of: UINavigationController.self))! {
            let nav = rootVC as! UINavigationController
            let activityVC = nav.viewControllers.last
            showNotification(message: tmpMessage, viewController: activityVC!)
            
        }else if (rootVC?.isKind(of: UIViewController.self))! {
            showNotification(message: tmpMessage, viewController: rootVC!)
        }
    }
    
    class func showNotification(message: String, viewController: UIViewController) {
        let noteView =  CSNotificationView(parentViewController: viewController, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: message)
        noteView?.setNoteAlpha(0.7)
        noteView?.setVisible(true, animated: true, completion: {
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                noteView?.setVisible(false, animated: true, completion: {
                })
            })
        })
        
    }
    
    func backClick() {
        SGLog(message: "")
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func confirmClick() {
        SGLog(message: "")
    }
}
