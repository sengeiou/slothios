//
//  UserInfoSingleView.swift
//  SlothChat
//
//  Created by Fly on 16/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserInfoSingleView: BaseView {
    
    let titleLabel = UILabel.init()
    let inputTextfield = UITextField.init()
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(titleLabel)
        let line = UIView.init()
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(88)
        }
        
        addSubview(inputTextfield)
        inputTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(-10)
        }
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(inputTextfield)
            make.height.equalTo(1)
        }
    }
    
    
    func configInputView(titleStr: String,contentStr: String) {
        titleLabel.text = titleStr
        inputTextfield.text = contentStr
    }
    
    func configContent(contentStr: String) {
        inputTextfield.text = contentStr
    }
    
    func getInputContent() -> String? {
        return inputTextfield.text
    }
    
    func getSumbitValid() -> Bool {
        let input = getInputContent()
        if (input?.isEmpty)! {
            return false
        }else{
            return true
        }
    }
}
