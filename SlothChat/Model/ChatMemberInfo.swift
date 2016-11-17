//
//	List.swift
//
//	Create by Fly on 16/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ChatMemberInfo : NSObject, NSCoding, Mappable{
    
    var memberUuid : String?
    var nickname : String?
    var profilePicUrl : String?
    var userProfileUuid : String?
    var userUuid : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ChatMemberInfo()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        memberUuid <- map["memberUuid"]
        nickname <- map["nickname"]
        profilePicUrl <- map["profilePicUrl"]
        userProfileUuid <- map["userProfileUuid"]
        userUuid <- map["userUuid"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        memberUuid = aDecoder.decodeObject(forKey: "memberUuid") as? String
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
        userProfileUuid = aDecoder.decodeObject(forKey: "userProfileUuid") as? String
        userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if memberUuid != nil{
            aCoder.encode(memberUuid, forKey: "memberUuid")
        }
        if nickname != nil{
            aCoder.encode(nickname, forKey: "nickname")
        }
        if profilePicUrl != nil{
            aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
        }
        if userProfileUuid != nil{
            aCoder.encode(userProfileUuid, forKey: "userProfileUuid")
        }
        if userUuid != nil{
            aCoder.encode(userUuid, forKey: "userUuid")
        }
        
    }
    
}
