//
//  swift
//  SlothChat
//
//  Created by fly on 2016/11/1.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class FlagView: UIView {

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
        
        let label = UILabel()
        addSubview(label)
        label.text = "推荐"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
    }
}
