//
//	UserPhotoList.swift
//
//	Create by Fly on 25/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class UserPhotoList : NSObject, NSCoding, Mappable{

	var orderNum : Int?
	var profilePicUrl : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return UserPhotoList()
	}
	required init?(map: Map){}
    override init(){}

	func mapping(map: Map)
	{
		orderNum <- map["orderNum"]
		profilePicUrl <- map["profilePicUrl"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         orderNum = aDecoder.decodeObject(forKey: "orderNum") as? Int
         profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if orderNum != nil{
			aCoder.encode(orderNum, forKey: "orderNum")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
