//
//  DiscoveryViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class DiscoveryViewController: BaseViewController {

    let controller3 = MyPhotosViewController()
    var pageMenu : CAPSPageMenu?

//    override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
//        get {
//            return true
//        }
//    }
    
//    deinit {
//        pageMenu?.removeObserver(self, forKeyPath: "currentPageIndex", context: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "探"
        setNavtionConfirm(imageStr: "camera-champagne")
        navigationItem.rightBarButtonItem?.tintColor = SGColor.black

        self.sentupView()

    }
    
    func sentupView() {
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 = GalleryViewController()
        controller1.displayType = .hottest
        controller1.title = "热门"
        controllerArray.append(controller1)
        let controller2  = GalleryViewController()
        controller2.displayType = .newest
        controller2.title = "最新"
        controllerArray.append(controller2)
        controller3.discoverVC = self
        controller3.title = "我"
        controllerArray.append(controller3)
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(SGColor.SGMainColor()),
            .bottomMenuHairlineColor(SGColor.SGLineColor()),
            .selectedMenuItemLabelColor(SGColor.SGMainColor()),
            .unselectedMenuItemLabelColor(SGColor.SGTextColor()),
            .menuItemFont(UIFont.systemFont(ofSize: 14)),
            .menuHeight(44.0),
            .menuItemWidth(90.0),
            .centerMenuItems(true)
        ]
        
        // Initialize scroll menu
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
//        pageMenu!.addObserver(self, forKeyPath: "currentPageIndex", options: .new, context: nil)
        pageMenu!.didMove(toParentViewController: self)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        SGLog(message: pageMenu!.currentPageIndex)
//    }
    
    // MARK: - Container View Controller
//    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
//        return true
//    }
    
//    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
//        return true
//    }

    //MARK:- Action
    
    override func confirmClick() {
        UIAlertController.photoPicker(withTitle: nil, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
            self.uploadPhotoToGallery(uploadImage: avatar!)
            }, onCancel:nil)
    }
   
    func uploadPhotoToGallery(uploadImage: UIImage?) {
        guard let uploadImage = uploadImage else {
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPhotoGallery(picFile: uploadImage) { (userPhoto) in
            HUD.hide()
            self.controller3.clearTmpUploadImage()
            
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                NotificationCenter.default.post(name: SGGlobalKey.DiscoveryDataDidChange, object: nil)

                let pushVC = PublishViewController()
                pushVC.userUuid = userPhoto?.data?.userUuid
                pushVC.galleryUuid = userPhoto?.data?.uuid
                pushVC.configWithObject(imageUrl: userPhoto?.data?.bigPicUrl)
                self.navigationController?.pushViewController(pushVC, animated: true)
            }else{
                HUD.flash(.label(userPhoto?.msg), delay: 2)
            }
        }
    }

}
