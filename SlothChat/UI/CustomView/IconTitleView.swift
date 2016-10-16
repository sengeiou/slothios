//
//  IconTitleView.swift
//  SlothChat
//
//  Created by Fly on 16/10/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class IconTitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sentupView() {
        let iconImgView = UIImageView.init(image: UIImage.init(named: "icon"))
        addSubview(iconImgView)
        
        let titleLabel = UILabel.init()
        titleLabel.text = "树懒"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = SGColor.SGMainColor()
        addSubview(titleLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-40)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        titleLabel.snp.makeConstraints  { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(40)
            make.centerY.equalTo(iconImgView.snp.centerY)
        }
    }
    
}
