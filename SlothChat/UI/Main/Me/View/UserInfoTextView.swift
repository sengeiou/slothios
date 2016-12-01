//
//  UserInfoTextView.swift
//  SlothChat
//
//  Created by Fly on 16/11/26.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserInfoTextView: UIView,UITextViewDelegate {
    
    let titleLabel = UILabel.init()
    
    let textView = UITextView.init()
    let line = UIView.init()
    var newlineCount = 1
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    init(type : InputType){
        self.init()
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 14)
        addSubview(textView)
        
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.equalTo(95)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.right.equalTo(-8)
        }
        
        
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(textView)
            make.height.equalTo(1)
        }
    }
    
    func setTextViewLeftMagin(left: Float) {
        titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(left - 4)
        }
    }
    
    func allowEditing(allowEdit: Bool) {
        textView.isEditable = allowEdit
        line.isHidden = !allowEdit
    }
    
    func configInputView(titleStr: String,contentStr: String) {
        titleLabel.text = titleStr
        textView.text = contentStr
    }
    
    func configContent(contentStr: String) {
        textView.text = contentStr
    }
    
    func setInputTextfieldLeftMagin(left: Float) {
        titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(left - 4)
        }
    }
    
    func getInputContent() -> String? {
        return textView.text
    }
    
    func getSumbitValid() -> Bool {
        let input = getInputContent()
        if (input?.isEmpty)! {
            return false
        }else{
            return true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let rangs = textView.text.findOccurencesOf(text: "\n")
            if rangs.count + 1 == newlineCount {
                textView.resignFirstResponder()
            }
        }
        return true
    }
}

extension String {
    func findOccurencesOf(text:String) -> [NSRange] {
        return !text.isEmpty ? try! NSRegularExpression(pattern: text, options: []).matches(in: self, options: [], range: NSRange(0..<characters.count)).map{ $0.range } : []
    }
}
