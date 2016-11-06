//
//	Data.swift
//
//	Create by Fly on 6/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class GalleryPhotoData : NSObject, NSCoding, Mappable{

	var adress : String?
	var adsImpressionOrderNum : Int?
	var bigPicUrl : String?
	var displayAsBidAds : Bool?
	var hdPicUrl : String?
	var likesCount : Int?
	var memo : String?
	var smallPicUrl : String?
	var userUuid : String?
	var uuid : String?


	class func newInstance(map: Map) -> Mappable?{
		return GalleryPhotoData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		adress <- map["adress"]
		adsImpressionOrderNum <- map["adsImpressionOrderNum"]
		bigPicUrl <- map["bigPicUrl"]
		displayAsBidAds <- map["displayAsBidAds"]
		hdPicUrl <- map["hdPicUrl"]
		likesCount <- map["likesCount"]
		memo <- map["memo"]
		smallPicUrl <- map["smallPicUrl"]
		userUuid <- map["userUuid"]
		uuid <- map["uuid"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         adress = aDecoder.decodeObject(forKey: "adress") as? String
         adsImpressionOrderNum = aDecoder.decodeObject(forKey: "adsImpressionOrderNum") as? Int
         bigPicUrl = aDecoder.decodeObject(forKey: "bigPicUrl") as? String
         displayAsBidAds = aDecoder.decodeObject(forKey: "displayAsBidAds") as? Bool
         hdPicUrl = aDecoder.decodeObject(forKey: "hdPicUrl") as? String
         likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
         memo = aDecoder.decodeObject(forKey: "memo") as? String
         smallPicUrl = aDecoder.decodeObject(forKey: "smallPicUrl") as? String
         userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
         uuid = aDecoder.decodeObject(forKey: "uuid") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if adress != nil{
			aCoder.encode(adress, forKey: "adress")
		}
		if adsImpressionOrderNum != nil{
			aCoder.encode(adsImpressionOrderNum, forKey: "adsImpressionOrderNum")
		}
		if bigPicUrl != nil{
			aCoder.encode(bigPicUrl, forKey: "bigPicUrl")
		}
		if displayAsBidAds != nil{
			aCoder.encode(displayAsBidAds, forKey: "displayAsBidAds")
		}
		if hdPicUrl != nil{
			aCoder.encode(hdPicUrl, forKey: "hdPicUrl")
		}
		if likesCount != nil{
			aCoder.encode(likesCount, forKey: "likesCount")
		}
		if memo != nil{
			aCoder.encode(memo, forKey: "memo")
		}
		if smallPicUrl != nil{
			aCoder.encode(smallPicUrl, forKey: "smallPicUrl")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if uuid != nil{
			aCoder.encode(uuid, forKey: "uuid")
		}

	}

}
