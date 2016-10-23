//
//  DiscoveryObj.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class DiscoveryUserObj: BaseObject {
    var usrId = 0
    var gender: SGGenderType = .male
    var name = ""
    var avatar = ""
    var phoneNo = ""
    var birthday = ""
    var location = ""
    var isLike = false
    var mainImgUrl = ""
    
    var likeUserList = [String]()

    class func getDiscoveryUserList() -> [DiscoveryUserObj] {
        var userList = [DiscoveryUserObj]()
        
        for _ in 0...20 {
            let user = DefaultDiscoveryUserObj()
            userList.append(user)
        }
        return userList
    }
    
    class func DefaultDiscoveryUserObj() -> DiscoveryUserObj {
        let user = DiscoveryUserObj()
        user.usrId = 100001
        user.name = "小恶魔"
        user.gender = .male
        user.location = "波士顿，纽约，多伦多，费城"
        user.phoneNo = "18667931202"
        user.avatar = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        user.mainImgUrl = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        user.isLike = (arc4random() % 2 == 0)
        user.birthday = "1987/12/02"
        let avatarList = [
            "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            ]
        user.likeUserList = avatarList;
        return user
    }
}
