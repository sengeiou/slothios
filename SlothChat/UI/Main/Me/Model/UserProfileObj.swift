//
//  UserProfileObj.swift
//  SlothChat
//
//  Created by Fly on 16/10/24.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//



import UIKit

class UserProfileObj: BaseObject {
    var age = 0
    var likesCount = 0

    var uuid = ""
    var userUuid = ""
    var nickname = ""
    var sex: SGGenderType = .male
    var userPhotoList: [UserPhotoObj]?
    var mobile = ""
    var country = ""
    
    var birthdate = ""
    var area = ""
    var commonCities = ""
    var school = ""
    var university = ""
    
}


class UserPhotoObj: BaseObject {
    var uuid = ""
    var orderNum = 0
    var profilePicUrl = ""
}
