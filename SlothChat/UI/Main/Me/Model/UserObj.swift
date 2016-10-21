//
//  UserObj.swift
//  SlothChat
//
//  Created by fly on 2016/10/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

let MaxAvatarCount: Int = 5

class UserObj: BaseObject,NSCoding {
    var usrId = 0
    var name = ""
    var gender: SGGenderType = .male
    var avatarList = ["","","","",""]
    var phoneNo = ""
    var birthday = ""
    var location = ""
    var haunt = ""
    var school = ""
    
    override init() {
        
    }
    
    class func defaultUserObj() -> UserObj {
        let user = UserObj()
        user.usrId = 100001
        user.name = "小恶魔"
        user.gender = .male
        user.phoneNo = "18667931202"
        user.birthday = "1987/12/02"
        user.location = "美国，波士顿"
        user.haunt = "波士顿，纽约，多伦多，费城"
        user.school = "波士顿大学"
        let avatarList = [
            "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
        ]
        user.avatarList = avatarList;
        return user
    }
    
    open func caheForUserInfo() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "UserInfoCacheKey")
    }
    
    open class func UserInfoFromCache() -> UserObj? {
        let data = UserDefaults.standard.value(forKey: "UserInfoCacheKey")
        if data != nil {
            let user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)  as! UserObj?
            let avatarList = [
                "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
                ]
            user?.avatarList = avatarList;
            return user
        }
        let userObj = UserObj.defaultUserObj()
        return userObj
    }
    
    func getBannerAvatarList() -> [String]{
        var bannerList = [String]()
        
        for avatar in self.avatarList {
            bannerList.append(avatar)
        }
        for _ in avatarList.count..<MaxAvatarCount{
            bannerList.append("camera-gray")
        }
        return bannerList
    }
    
    func setNewAvatar(newAvatar: String,at: Int) {
        var avatarList = self.getBannerAvatarList()
        if at >= MaxAvatarCount || at < 0{
            SGLog(message: "at出错" + String(at))
            return
        }
        if newAvatar.isEmpty {
            SGLog(message: "头像为空" + newAvatar)
            return
        }
        avatarList[at] = newAvatar
        self.avatarList = avatarList
    }
    
    func deleteAvatar(at: Int) {
        if at <= 0 || at > self.avatarList.count  {
            SGLog(message: "page出错" + String(at))
            return
        }
        avatarList[at] = "pen"
    }
    
    //MARK:- NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.usrId, forKey: "usrId")
        aCoder.encode(self.gender, forKey: "gender")
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.birthday, forKey: "birthday")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.haunt, forKey: "haunt")
        aCoder.encode(self.school, forKey: "school")
        aCoder.encode(self.avatarList, forKey: "avatarList")
        aCoder.encode(self.phoneNo, forKey: "phoneNo")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.usrId, forKey: "usrId")
        aCoder.encode(self.gender.rawValue, forKey: "gender")
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.birthday, forKey: "birthday")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.haunt, forKey: "haunt")
        aCoder.encode(self.school, forKey: "school")
        aCoder.encode(self.avatarList, forKey: "avatarList")
        aCoder.encode(self.phoneNo, forKey: "phoneNo")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        self.usrId = Int(aDecoder.decodeInt32(forKey: "usrId"))
        self.gender = SGGenderType(rawValue: Int(aDecoder.decodeInt32(forKey: "gender")))!
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.haunt = aDecoder.decodeObject(forKey: "haunt") as! String
        self.school = aDecoder.decodeObject(forKey: "school") as! String
        self.phoneNo = aDecoder.decodeObject(forKey: "phoneNo") as! String
    }
}

