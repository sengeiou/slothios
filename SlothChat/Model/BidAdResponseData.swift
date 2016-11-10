//
//	Data.swift
//
//	Create by Fly on 10/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BidAdResponseData : NSObject, NSCoding, Mappable{

	var accountsBanlace : Int?
	var bidGalleryUuid : String?
	var isPaid : Bool?
	var needPayAmount : Int?


	class func newInstance(map: Map) -> Mappable?{
		return BidAdResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		accountsBanlace <- map["accountsBanlace"]
		bidGalleryUuid <- map["bidGalleryUuid"]
		isPaid <- map["isPaid"]
		needPayAmount <- map["needPayAmount"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         accountsBanlace = aDecoder.decodeObject(forKey: "accountsBanlace") as? Int
         bidGalleryUuid = aDecoder.decodeObject(forKey: "bidGalleryUuid") as? String
         isPaid = aDecoder.decodeObject(forKey: "isPaid") as? Bool
         needPayAmount = aDecoder.decodeObject(forKey: "needPayAmount") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if accountsBanlace != nil{
			aCoder.encode(accountsBanlace, forKey: "accountsBanlace")
		}
		if bidGalleryUuid != nil{
			aCoder.encode(bidGalleryUuid, forKey: "bidGalleryUuid")
		}
		if isPaid != nil{
			aCoder.encode(isPaid, forKey: "isPaid")
		}
		if needPayAmount != nil{
			aCoder.encode(needPayAmount, forKey: "needPayAmount")
		}

	}

}
