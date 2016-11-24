//
//  SGVoiceMessageCell.swift
//  SlothChat
//
//  Created by fly on 2016/11/24.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SnapKit

class SGVoiceMessageCell: RCVoiceMessageCell {
    
    let clockImgView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView()  {
        clockImgView.image = UIImage(named:"icon-clock")
        self.addSubview(clockImgView)
        
        clockImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.bubbleBackgroundView.snp.centerY)
            make.left.equalTo(self.bubbleBackgroundView.snp.right).offset(18)
        }
    }
}
