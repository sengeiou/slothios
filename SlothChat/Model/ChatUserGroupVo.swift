//
//	ChatUserGroupVo.swift
//
//	Create by Fly on 16/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ChatUserGroupVo : NSObject, NSCoding, Mappable{

	var userGroupMemberVos : [ChatMemberInfo]?
	var userGroupName : String?
	var userGroupUuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return ChatUserGroupVo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		userGroupMemberVos <- map["userGroupMemberVos"]
		userGroupName <- map["userGroupName"]
		userGroupUuid <- map["userGroupUuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         userGroupMemberVos = aDecoder.decodeObject(forKey: "userGroupMemberVos") as? [ChatMemberInfo]
         userGroupName = aDecoder.decodeObject(forKey: "userGroupName") as? String
         userGroupUuid = aDecoder.decodeObject(forKey: "userGroupUuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if userGroupMemberVos != nil{
			aCoder.encode(userGroupMemberVos, forKey: "userGroupMemberVos")
		}
		if userGroupName != nil{
			aCoder.encode(userGroupName, forKey: "userGroupName")
		}
		if userGroupUuid != nil{
			aCoder.encode(userGroupUuid, forKey: "userGroupUuid")
		}

	}

}
