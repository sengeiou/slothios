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
    var bidProductId : String?
	var isPaid : Bool?
	var needPayAmount : Int?
    var itunesChargeAmount : Int?
    var itunesChargeProductUuid : String?



	class func newInstance(map: Map) -> Mappable?{
		return BidAdResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		accountsBanlace <- map["accountsBanlace"]
		bidGalleryUuid <- map["bidGalleryUuid"]
        bidProductId <- map["bidProductId"]
		isPaid <- map["isPaid"]
		needPayAmount <- map["needPayAmount"]
        itunesChargeAmount <- map["itunesChargeAmount"]
        itunesChargeProductUuid <- map["itunesChargeProductUuid"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         accountsBanlace = aDecoder.decodeObject(forKey: "accountsBanlace") as? Int
         bidGalleryUuid = aDecoder.decodeObject(forKey: "bidGalleryUuid") as? String
         bidProductId = aDecoder.decodeObject(forKey: "bidProductId") as? String
         isPaid = aDecoder.decodeObject(forKey: "isPaid") as? Bool
         needPayAmount = aDecoder.decodeObject(forKey: "needPayAmount") as? Int
         itunesChargeAmount = aDecoder.decodeObject(forKey: "itunesChargeAmount") as? Int
         itunesChargeProductUuid = aDecoder.decodeObject(forKey: "itunesChargeProductUuid") as? String
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
        if bidProductId != nil{
            aCoder.encode(bidGalleryUuid, forKey: "bidProductId")
        }
		if isPaid != nil{
			aCoder.encode(isPaid, forKey: "isPaid")
		}
		if needPayAmount != nil{
			aCoder.encode(needPayAmount, forKey: "needPayAmount")
		}
        if itunesChargeAmount != nil{
            aCoder.encode(itunesChargeAmount, forKey: "itunesChargeAmount")
        }
        if itunesChargeProductUuid != nil{
            aCoder.encode(itunesChargeProductUuid, forKey: "itunesChargeProductUuid")
        }
	}

}
