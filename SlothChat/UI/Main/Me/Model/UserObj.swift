//
//  UserObj.swift
//  SlothChat
//
//  Created by fly on 2016/10/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserObj: BaseObject {
    var usrId = 0
    var name = ""
    var gender = .male
    var avatarList = [String]()
    var brithday = ""
    var location = ""
    var haunt = ""
    var school = ""
    
    func defaultUserObj() {
        usrId = 100001
        name = "小恶魔"
        gender = .male
//        nameLabel.text = "小恶魔"
//        sexImgView.image = UIImage.init(named: "female")
//        ageInfoLabel.text = "25，处女座"
//        
//        locationView.configContent(contentStr: "美国，波士顿")
//        hauntView.configContent(contentStr: "波士顿，纽约，多伦多，费城")
//        schoolView.configContent(contentStr: "波士顿大学")
    }
}
