//
//	ChatOfficialGroupVo.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class ChatOfficialGroupVo : NSObject, NSCoding, Mappable{
    
    var officialGroupMemberVos : [ChatMemberInfo]?
    var officialGroupName : String?
    var officialGroupUuid : String?
    var topicMsg : String?
    var topicPicUrl : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ChatOfficialGroupVo()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        officialGroupMemberVos <- map["officialGroupMemberVos"]
        officialGroupName <- map["officialGroupName"]
        officialGroupUuid <- map["officialGroupUuid"]
        topicMsg <- map["topicMsg"]
        topicPicUrl <- map["topicPicUrl"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        officialGroupMemberVos = aDecoder.decodeObject(forKey: "officialGroupMemberVos") as? [ChatMemberInfo]
        officialGroupName = aDecoder.decodeObject(forKey: "officialGroupName") as? String
        officialGroupUuid = aDecoder.decodeObject(forKey: "officialGroupUuid") as? String
        topicMsg = aDecoder.decodeObject(forKey: "topicMsg") as? String
        topicPicUrl = aDecoder.decodeObject(forKey: "topicPicUrl") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if officialGroupMemberVos != nil{
            aCoder.encode(officialGroupMemberVos, forKey: "officialGroupMemberVos")
        }
        if officialGroupName != nil{
            aCoder.encode(officialGroupName, forKey: "officialGroupName")
        }
        if officialGroupUuid != nil{
            aCoder.encode(officialGroupUuid, forKey: "officialGroupUuid")
        }
        if topicMsg != nil{
            aCoder.encode(topicMsg, forKey: "topicMsg")
        }
        if topicPicUrl != nil{
            aCoder.encode(topicPicUrl, forKey: "topicPicUrl")
        }
        
    }
    
}
