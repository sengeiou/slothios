//
//  SingleInputView.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import SnapKit

enum InputType {
    case textField
    case button
}
typealias SelectClosureType = () -> Void

class SingleInputView: UIView {

    let titleLabel = UILabel.init()
    let errorLabel = UILabel.init()
    
    let inputTextfield = UITextField.init()
    
    let selectButton = UIButton.init()
    let arrowImgView = UIImageView.init()
    
    var inputType : InputType = .textField
    var selectPassValue:SelectClosureType?
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        inputType = .textField
        sentupView()
    }
    
    init(type : InputType){
        self.init()
        inputType = type
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
            make.left.equalTo(4)
            make.bottom.equalTo(0)
            make.width.equalTo(128)
        }
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.textColor = SGColor.SGRedColor()
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.top.equalTo(0)
            make.height.equalTo(16)
        }
        
        addSubview(inputTextfield)
        inputTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
            make.top.equalTo(errorLabel.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(-4)
        }
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(inputTextfield)
            make.height.equalTo(1)
        }
        switch inputType {
            
        case .button:
            addSubview(selectButton)
            selectButton.addTarget(self, action:#selector(selectButtonClick), for: .touchUpInside)
            addSubview(arrowImgView)
            selectButton.snp.makeConstraints { (make) in
                make.left.equalTo(inputTextfield.snp.left)
                make.top.bottom.equalTo(inputTextfield)
                make.right.equalTo(inputTextfield.snp.right)
            }
            arrowImgView.image = UIImage.init(named: "go-right")
            arrowImgView.snp.makeConstraints { (make) in
                make.right.equalTo(-4)
                make.centerY.equalTo(self.snp.centerY)
                make.right.equalTo(-4)
                make.size.equalTo(CGSize.init(width: 16, height: 16))
            }
            line.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(inputTextfield)
                make.height.equalTo(1)
            }
        default:
            print("default")
        }
            
        
    }
    
    func setClosurePass(temClosure: @escaping SelectClosureType){
        self.selectPassValue = temClosure
    }
    
    func selectButtonClick() {
        if let sp = self.selectPassValue {
            sp()
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
    
    func setErrorContent(error: String?) {
        if let error = error {
            errorLabel.text = error
            inputTextfield.backgroundColor = UIColor(red:0.99, green:0.91, blue:0.91, alpha:1.00)
        }else{
            errorLabel.text = ""
            inputTextfield.backgroundColor = UIColor.white
        }
    }
    
}
