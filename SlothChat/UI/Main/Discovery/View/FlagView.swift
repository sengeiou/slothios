//
//  swift
//  SlothChat
//
//  Created by fly on 2016/11/1.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class FlagView: UIView {
    
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configSelf()
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configSelf() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
    
    fileprivate func sentupView() {
        
        addSubview(label)
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
    }
    
    func setIsDisplayAsBidAds(displayAsBidAds: Bool) {
        if displayAsBidAds {
            self.isHidden = false
            label.text = "推荐"
        }
    }
    
    func setIsParticipateBidAds(participateBidAds: Bool) {
        if participateBidAds {
            self.isHidden = false
            label.text = "竞价中"
        }
    }
}
