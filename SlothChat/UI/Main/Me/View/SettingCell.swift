//
//  SettingCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let selectButton = UIButton(type: .custom)
    let arrowImgView = UIImageView()
    var dependVC: SettingViewController!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(selectButton)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        contentLabel.textColor = SGColor.SGMainColor()
        contentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        selectButton.alpha = 0.7
        selectButton.setBackgroundImage(UIImage.init(named: "button-no"), for: .normal)
        selectButton.setBackgroundImage(UIImage.init(named: "button-yes"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectButtonCLick), for: .touchUpInside)
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 70, height: 40))
        }
    }
    
    func configCellWithObj(settingObj: SettingObj) {
        titleLabel.text = settingObj.titleStr
        if settingObj.contentStr.isEmpty {
            contentLabel.text = ""
            if settingObj.titleStr == "接受私信" ||
                settingObj.titleStr == "接受通知"{
                selectButton.isHidden = false
                selectButton.isSelected = settingObj.isOn
            }else{
                selectButton.isHidden = true
            }
        }else{
            contentLabel.text = settingObj.contentStr
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectButtonCLick() {
        let isSysNotify = (titleLabel.text  == "接受通知")
        self.modifySystemConfig(isSelect: !selectButton.isSelected, isSysNotify: isSysNotify)
    }

    //MARK:- Network
    
    func modifySystemConfig(isSelect:Bool,isSysNotify:Bool) {
        let engine = NetworkEngine()
        self.dependVC.showNotificationProgress()
        
        var sysNotify = Global.shared.globalSysConfig?.acceptSysNotify
        var privateChat = Global.shared.globalSysConfig?.acceptPrivateChat
        
        if isSysNotify {
            sysNotify = isSelect
        }else{
            privateChat = isSelect
        }
        
        engine.putSysConfig(isAcceptSysNotify: sysNotify!, isAcceptPrivateChat: privateChat!) { (response) in
            self.dependVC.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                self.selectButton.isSelected = isSelect
                if isSysNotify {
                    Global.shared.globalSysConfig?.acceptSysNotify = isSelect
                }else{
                    Global.shared.globalSysConfig?.acceptPrivateChat = isSelect
                }
                Global.shared.globalSysConfig?.cacheForSysConfig()
                
            }else{
                UIViewController.showCurrentViewControllerNotificationError(message: response?.msg)
            }
        }
    }
}
