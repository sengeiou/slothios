//
//  UserInfoSingleView.swift
//  SlothChat
//
//  Created by Fly on 16/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserInfoSingleView: BaseView {
    
    let titleLabel = UILabel()
    let contenLabel = UILabel()
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(80)
        }
        
        contenLabel.lineBreakMode = .byCharWrapping
        contenLabel.numberOfLines = 0
        let screenWidth = UIScreen.main.bounds.size.width
        contenLabel.preferredMaxLayoutWidth = screenWidth - 80 - 10
        
        addSubview(contenLabel)
        contenLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
    }
    
    func configContent(contentStr: String) {
        contenLabel.text = contentStr
    }
    
    func configInputView(titleStr: String,contentStr: String) {
        titleLabel.text = titleStr
        contenLabel.text = contentStr
    }
}
