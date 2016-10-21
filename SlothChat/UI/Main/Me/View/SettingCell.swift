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
    let mSwitch = UISwitch()
    let arrowImgView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(mSwitch)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        contentLabel.textColor = SGColor.SGMainColor()
        contentLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        mSwitch.onTintColor = SGColor.SGMainColor()
        mSwitch.backgroundColor = UIColor.init(red: 229/255.0, green: 202/255.0, blue: 182/255.0, alpha: 1.0)
        mSwitch.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
    }
    
    func configCellWithObj(settingObj: SettingObj) {
        titleLabel.text = settingObj.titleStr
        if settingObj.contentStr.isEmpty {
            contentLabel.text = ""
            if settingObj.titleStr == "接受私信" ||
                settingObj.titleStr == "接受通知"{
                mSwitch.isHidden = false
                mSwitch.isOn = settingObj.isOn
            }else{
                mSwitch.isHidden = true
            }
        }else{
            contentLabel.text = settingObj.contentStr
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
