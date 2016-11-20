//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        textField.layer.cornerRadius = 15
        
        let label = UILabel()
        label.text = "￥"
        label.textAlignment = .center
        label.frame = CGRect.init(x: 0, y: 0, width: 28, height: 37)
        
        textField.keyboardType = .numberPad
        textField.leftView = label
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.layer.borderWidth = 1.0
        textField.placeholder = "请输入充值金额"
        textField.layer.borderColor = SGColor.SGLineColor().cgColor
        textField.setValue(SGColor.SGLineColor(), forKeyPath: "_placeholderLabel.textColor")
    }
    
    func endEditing() {
        view.endEditing(true)
    }
}

extension RatingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
