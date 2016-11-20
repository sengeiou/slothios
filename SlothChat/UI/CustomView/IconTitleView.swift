//
//  IconTitleView.swift
//  SlothChat
//
//  Created by Fly on 16/10/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class IconTitleView: UIView {
    let titleLabel = UILabel.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sentupView() {
        let iconImgView = UIImageView.init(image: UIImage(named: "icon"))
        addSubview(iconImgView)
        
        titleLabel.text = "树懒"
        titleLabel.font = UIFont.systemFont(ofSize: 36)
        titleLabel.textColor = SGColor.SGMainColor()
        addSubview(titleLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(0)
            make.height.equalTo(self.snp.height)
            make.width.equalTo(self.snp.height)
        }
        titleLabel.snp.makeConstraints  { (make) in
            make.right.equalTo(0)
            make.centerY.equalTo(iconImgView.snp.centerY)
        }
    }
    
}
