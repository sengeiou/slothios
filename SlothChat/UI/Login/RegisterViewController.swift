//
//  RegisterViewController.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit
import SnapKit

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupViews()
    }

    func sentupViews() {
        let iconImgView = UIImageView.init(image: UIImage.init(named: ""))
        view.addSubview(iconImgView)
        
        let titleLabel = UILabel.init()
        titleLabel.text = "树懒"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor.red
        view.addSubview(titleLabel)
        
        iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalTo(self.view).offset(-40)
        }
        titleLabel.snp.makeConstraints  { (make) in
            make.left.equalTo(iconImgView.snp.right).offset(40)
            make.centerY.equalTo(iconImgView.snp.centerY)
        }
        
        let phoneView = SingleInputView.init()
        phoneView.configInputView(titleStr: "手机号:", textfieldPlaceHolder: "")
        view.addSubview(phoneView)
        
        let passwordView = SingleInputView.init()
        passwordView.configInputView(titleStr: "密码:", textfieldPlaceHolder: "")
        view.addSubview(passwordView)
        
        phoneView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(180)
            make.height.equalTo(44)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(phoneView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
