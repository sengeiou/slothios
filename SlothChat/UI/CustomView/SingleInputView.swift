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

class SingleInputView: UIView,UITextFieldDelegate {

    let titleLabel = UILabel.init()
    let errorLabel = UILabel.init()
    
    let inputTextfield = UITextField.init()
    let line = UIView.init()

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
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        
        inputTextfield.font = UIFont.systemFont(ofSize: 14)
        addSubview(inputTextfield)
        
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(95)
        }
        errorLabel.font = UIFont.systemFont(ofSize: 11)
        errorLabel.textColor = SGColor.SGRedColor()
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.top.equalTo(0)
        }
        inputTextfield.delegate = self
        inputTextfield.clearButtonMode = .whileEditing
        inputTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right)
//            make.top.equalTo(errorLabel.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(-8)
            make.height.equalTo(44)
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
                make.right.equalTo(-10)
                make.centerY.equalTo(self.snp.centerY)
                make.right.equalTo(-10)
                make.size.equalTo(CGSize.init(width: 16, height: 16))
            }
            line.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(inputTextfield)
                make.height.equalTo(1)
            }
        default:
            SGLog(message: "")
        }
    }
    
    func setInputTextfieldLeftMagin(left: Float) {
        titleLabel.snp.updateConstraints { (make) in
            make.width.equalTo(left - 4)
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
    
    func allowEditing(allowEdit: Bool) {
        inputTextfield.isEnabled = allowEdit
        line.isHidden = !allowEdit
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
            UIView.animate(withDuration: 0.3, animations: {
                self.inputTextfield.backgroundColor = UIColor(red:0.99, green:0.91, blue:0.91, alpha:1.0)
            })
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.setErrorContent(error: nil)
            }
        }else{
            errorLabel.text = ""
            UIView.animate(withDuration: 0.3, animations: { 
                self.inputTextfield.backgroundColor = UIColor.white
            })
        }
    }
    
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
