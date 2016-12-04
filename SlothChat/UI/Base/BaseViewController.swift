//
//  BaseViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var isMyselfShow = false
    var noteView: CSNotificationView?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isMyselfShow = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isMyselfShow = false
        if let noteView = noteView{
            self.hiddenNotificationProgress(noteView: noteView, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        if self.navigationController != nil &&
            (self.navigationController?.viewControllers.count)! > 1 {
            self.setNavtionBack(imageStr: "go-back")
        }
    }
    
    deinit {
        SGLog(message: String(describing: self))
    }
    
    func showAlertView(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showNotificationProgress() {
        self.noteView =  self.showNotificationProgress(message: nil)
    }
    func hiddenNotificationProgress(animated: Bool) {
        if let noteView = self.noteView{
            self.hiddenNotificationProgress(noteView: noteView, animated: animated)
        }
    }
}
