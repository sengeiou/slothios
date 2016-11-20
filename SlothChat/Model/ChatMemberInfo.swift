//
//	ChatMemberInfo.swift
//
//	Create by Fly on 17/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ChatMemberInfo : NSObject, NSCoding, Mappable{
    
    var isAdmin : Bool?
    var memberUuid : String?
    var profilePicUrl : String?
    var userDisplayName : String?
    var userProfileUuid : String?
    var userUuid : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ChatMemberInfo()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        isAdmin <- map["isAdmin"]
        memberUuid <- map["memberUuid"]
        profilePicUrl <- map["profilePicUrl"]
        userDisplayName <- map["userDisplayName"]
        userProfileUuid <- map["userProfileUuid"]
        userUuid <- map["userUuid"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        isAdmin = aDecoder.decodeObject(forKey: "isAdmin") as? Bool
        memberUuid = aDecoder.decodeObject(forKey: "memberUuid") as? String
        profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
        userDisplayName = aDecoder.decodeObject(forKey: "userDisplayName") as? String
        userProfileUuid = aDecoder.decodeObject(forKey: "userProfileUuid") as? String
        userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if isAdmin != nil{
            aCoder.encode(isAdmin, forKey: "isAdmin")
        }
        if memberUuid != nil{
            aCoder.encode(memberUuid, forKey: "memberUuid")
        }
        if profilePicUrl != nil{
            aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
        }
        if userDisplayName != nil{
            aCoder.encode(userDisplayName, forKey: "userDisplayName")
        }
        if userProfileUuid != nil{
            aCoder.encode(userProfileUuid, forKey: "userProfileUuid")
        }
        if userUuid != nil{
            aCoder.encode(userUuid, forKey: "userUuid")
        }
        
    }
    
}
