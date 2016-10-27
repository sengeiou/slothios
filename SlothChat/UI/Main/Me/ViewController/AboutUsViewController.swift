//
//  AboutUsViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/18.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "关于我们"
        sentupView()
    }
    
    func sentupView() {
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
        view.addSubview(imageView)
//        [[NSBundle mainBundle]                                                       \
//            objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//        let version = NSBundle.mainBundle().objectForInfoDictionaryKey
        
//        let version =  Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let label = UILabel.init()
        label.text = "一只无畏躁动的创始者\n一群新新世纪的宝宝们\n私信撩我们？Busy@ets.cc"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        let w = UIScreen.main.bounds.width
        label.preferredMaxLayoutWidth = w - 40
        view.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.snp.centerY).offset(-88)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize.init(width: 122, height: 122))
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.left.greaterThanOrEqualTo(20)
            make.right.lessThanOrEqualTo(-20)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
}
