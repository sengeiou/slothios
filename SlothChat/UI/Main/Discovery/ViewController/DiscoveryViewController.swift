//
//  DiscoveryViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class DiscoveryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "探"
        setNavtionConfirm(imageStr: "camera-champagne")
        self.navigationItem.rightBarButtonItem?.tintColor = SGColor.SGMainColor()

        // Do any additional setup after loading the view.
    }
    var pageMenu : CAPSPageMenu?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - UI Setup
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        let controller1 = HotestViewController()
        controller1.title = "热门"
        controllerArray.append(controller1)
        let controller2  = NewestViewController()
        controller2.title = "最新"
        controllerArray.append(controller2)
        let controller3 = MyPhotosViewController()
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
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect.init(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
    }
    
    
    // MARK: - Container View Controller
//    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
//        return true
//    }
    
    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }

    //MARK:- Action
    
    override func confirmClick() {
        self.publishAdvert(image: UIImage.init(named: "litmatrix")!)

//        UIActionSheet.photoPicker(withTitle: nil, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
//            self.publishAdvert(image: avatar!)
//            }, onCancel:nil)
    }
    func publishAdvert(image: UIImage) {
        let pushVC = BiddingStatusViewController()
        pushVC.configWithObject(image: image)
        self.navigationController?.pushViewController(pushVC, animated: true)
    }

}
