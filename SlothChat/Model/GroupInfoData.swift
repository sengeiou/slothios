//
//	Data.swift
//
//	Create by Fly on 15/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class GroupInfoData : NSObject, NSCoding, Mappable{

	var country : String?
	var coverPicUrl : String?
	var groupDisplayName : String?
	var topicMsg : String?
	var topicPicUrl : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return GroupInfoData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		country <- map["country"]
		coverPicUrl <- map["coverPicUrl"]
		groupDisplayName <- map["groupDisplayName"]
		topicMsg <- map["topicMsg"]
		topicPicUrl <- map["topicPicUrl"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         country = aDecoder.decodeObject(forKey: "country") as? String
         coverPicUrl = aDecoder.decodeObject(forKey: "coverPicUrl") as? String
         groupDisplayName = aDecoder.decodeObject(forKey: "groupDisplayName") as? String
         topicMsg = aDecoder.decodeObject(forKey: "topicMsg") as? String
         topicPicUrl = aDecoder.decodeObject(forKey: "topicPicUrl") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if coverPicUrl != nil{
			aCoder.encode(coverPicUrl, forKey: "coverPicUrl")
		}
		if groupDisplayName != nil{
			aCoder.encode(groupDisplayName, forKey: "groupDisplayName")
		}
		if topicMsg != nil{
			aCoder.encode(topicMsg, forKey: "topicMsg")
		}
		if topicPicUrl != nil{
			aCoder.encode(topicPicUrl, forKey: "topicPicUrl")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
