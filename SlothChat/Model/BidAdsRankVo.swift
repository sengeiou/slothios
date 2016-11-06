//
//	BidAdsRankVo.swift
//
//	Create by Fly on 6/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BidAdsRankVo : NSObject, NSCoding, Mappable{

	var bidGalleryUuid : String?
	var bidTotalAmount : Int?
	var biddingEndTime : Int?
	var biddingStartTime : Int?
	var nickname : String?
	var profilePicUrl : String?
	var rank : Int?
	var userUuid : String?
	var visitorMyself : Bool?


	class func newInstance(map: Map) -> Mappable?{
		return BidAdsRankVo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		bidGalleryUuid <- map["bidGalleryUuid"]
		bidTotalAmount <- map["bidTotalAmount"]
		biddingEndTime <- map["biddingEndTime"]
		biddingStartTime <- map["biddingStartTime"]
		nickname <- map["nickname"]
		profilePicUrl <- map["profilePicUrl"]
		rank <- map["rank"]
		userUuid <- map["userUuid"]
		visitorMyself <- map["visitorMyself"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bidGalleryUuid = aDecoder.decodeObject(forKey: "bidGalleryUuid") as? String
         bidTotalAmount = aDecoder.decodeObject(forKey: "bidTotalAmount") as? Int
         biddingEndTime = aDecoder.decodeObject(forKey: "biddingEndTime") as? Int
         biddingStartTime = aDecoder.decodeObject(forKey: "biddingStartTime") as? Int
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
         rank = aDecoder.decodeObject(forKey: "rank") as? Int
         userUuid = aDecoder.decodeObject(forKey: "userUuid") as? String
         visitorMyself = aDecoder.decodeObject(forKey: "visitorMyself") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bidGalleryUuid != nil{
			aCoder.encode(bidGalleryUuid, forKey: "bidGalleryUuid")
		}
		if bidTotalAmount != nil{
			aCoder.encode(bidTotalAmount, forKey: "bidTotalAmount")
		}
		if biddingEndTime != nil{
			aCoder.encode(biddingEndTime, forKey: "biddingEndTime")
		}
		if biddingStartTime != nil{
			aCoder.encode(biddingStartTime, forKey: "biddingStartTime")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
		}
		if rank != nil{
			aCoder.encode(rank, forKey: "rank")
		}
		if userUuid != nil{
			aCoder.encode(userUuid, forKey: "userUuid")
		}
		if visitorMyself != nil{
			aCoder.encode(visitorMyself, forKey: "visitorMyself")
		}

	}

}
