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
        
        let label = UILabel.init()
        label.text = "Copyright @ 2016 树懒"
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(185)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(CGSize.init(width: 122, height: 122))
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(36)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
}
