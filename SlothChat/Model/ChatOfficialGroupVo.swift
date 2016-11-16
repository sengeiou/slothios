//
//	ChatOfficialGroupVo.swift
//
//	Create by Fly on 16/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ChatOfficialGroupVo : NSObject, NSCoding, Mappable{

	var officialGroupMemberVos : [ChatMemberInfo]?
	var topicMsg : String?
	var topicPicUrl : String?
	var userGroupName : String?
	var userGroupUuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return ChatOfficialGroupVo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		officialGroupMemberVos <- map["officialGroupMemberVos"]
		topicMsg <- map["topicMsg"]
		topicPicUrl <- map["topicPicUrl"]
		userGroupName <- map["userGroupName"]
		userGroupUuid <- map["userGroupUuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         officialGroupMemberVos = aDecoder.decodeObject(forKey: "officialGroupMemberVos") as? [ChatMemberInfo]
         topicMsg = aDecoder.decodeObject(forKey: "topicMsg") as? String
         topicPicUrl = aDecoder.decodeObject(forKey: "topicPicUrl") as? String
         userGroupName = aDecoder.decodeObject(forKey: "userGroupName") as? String
         userGroupUuid = aDecoder.decodeObject(forKey: "userGroupUuid") as? String

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
		if topicMsg != nil{
			aCoder.encode(topicMsg, forKey: "topicMsg")
		}
		if topicPicUrl != nil{
			aCoder.encode(topicPicUrl, forKey: "topicPicUrl")
		}
		if userGroupName != nil{
			aCoder.encode(userGroupName, forKey: "userGroupName")
		}
		if userGroupUuid != nil{
			aCoder.encode(userGroupUuid, forKey: "userGroupUuid")
		}

	}

}
