//
//  SingleInputView.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import SnapKit

class SingleInputView: UIView {
    let titleLabel = UILabel.init()
    let inputTextfield = UITextField.init()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(titleLabel)
        addSubview(inputTextfield)
        let line = UIView.init()
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(4)
            make.bottom.equalTo(0)
            make.width.equalTo(100)
        }
        inputTextfield.snp_makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp_right)
            make.top.bottom.equalTo(0)
            make.right.equalTo(-4)
        }
        line.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(inputTextfield)
            make.height.equalTo(1)
        }
    }
    
    func configInputView(titleStr: String,textfieldPlaceHolder: String) {
        titleLabel.text = titleStr
        inputTextfield.placeholder = textfieldPlaceHolder
    }
    
}
