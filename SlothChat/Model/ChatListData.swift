//
//	Data.swift
//
//	Create by Fly on 13/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ChatListData : NSObject, NSCoding, Mappable{

	var chatOfficialGroupVo : ChatOfficialGroupVo?
	var chatUserGroupVos : [AnyObject]?
	var privateChatVos : [AnyObject]?


	class func newInstance(map: Map) -> Mappable?{
		return ChatListData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		chatOfficialGroupVo <- map["chatOfficialGroupVo"]
		chatUserGroupVos <- map["chatUserGroupVos"]
		privateChatVos <- map["privateChatVos"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chatOfficialGroupVo = aDecoder.decodeObject(forKey: "chatOfficialGroupVo") as? ChatOfficialGroupVo
         chatUserGroupVos = aDecoder.decodeObject(forKey: "chatUserGroupVos") as? [AnyObject]
         privateChatVos = aDecoder.decodeObject(forKey: "privateChatVos") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if chatOfficialGroupVo != nil{
			aCoder.encode(chatOfficialGroupVo, forKey: "chatOfficialGroupVo")
		}
		if chatUserGroupVos != nil{
			aCoder.encode(chatUserGroupVos, forKey: "chatUserGroupVos")
		}
		if privateChatVos != nil{
			aCoder.encode(privateChatVos, forKey: "privateChatVos")
		}

	}

}