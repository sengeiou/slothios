//
//  UserObj.swift
//  SlothChat
//
//  Created by fly on 2016/10/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class UserObj: BaseObject,NSCoding {

    var usrId = 0
    var name = ""
    var gender: SGGenderType = .male
    var avatarList = [String]()
    var birthday = ""
    var location = ""
    var haunt = ""
    var school = ""
    
    class func defaultUserObj() -> UserObj {
        let user = UserObj()
        user.usrId = 100001
        user.name = "小恶魔"
        user.gender = .male
        user.birthday = "1987/12/02"
        user.location = "美国，波士顿"
        user.haunt = "波士顿，纽约，多伦多，费城"
        user.school = "波士顿大学"
        return user
    }
    
    open func cacheForUserDefault() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.setValue(data, forKey: "UserInfoCacheKey")
    }
    
    open func getUserInfoFromUserDefault() -> UserObj? {
        let data = UserDefaults.standard.value(forKey: "UserInfoCacheKey")
        if data != nil {
            let userObj = NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
            return userObj
        }
        
        return nil
    }
    
    
    //MARK:- NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.usrId, forKey: "usrId")
        aCoder.encode(self.gender, forKey: "gender")
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.birthday, forKey: "birthday")
        aCoder.encode(self.location, forKey: "location")
        aCoder.encode(self.haunt, forKey: "haunt")
        aCoder.encode(self.school, forKey: "school")
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        
        self.usrId = Int(aDecoder.decodeInt32(forKey: "usrId"))
        self.gender = aDecoder.decodeObject(forKey: "gender") as! SGGenderType
        
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.birthday = aDecoder.decodeObject(forKey: "birthday") as! String
        self.location = aDecoder.decodeObject(forKey: "location") as! String
        self.haunt = aDecoder.decodeObject(forKey: "haunt") as! String
        self.school = aDecoder.decodeObject(forKey: "school") as! String
    }
}

