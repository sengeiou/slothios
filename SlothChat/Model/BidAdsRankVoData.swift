//
//	Data.swift
//
//	Create by Fly on 6/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BidAdsRankVoData : NSObject, NSCoding, Mappable{

	var bidAdsRankVos : [BidAdsRankVo]?
	var bidGalleryUuid : String?
	var biddingEndTime : Int?
	var biddingStartTime : Int?
	var bidsEnd : Bool?
	var bigPicUrl : String?
	var currentVisitorLiked : Bool?
	var hdPicUrl : String?
	var leftDaysHours : String?
	var likeGallerySliceList : [DisplayOrderPhotoSlice]?
	var likesCount : Int?
	var myBidAmount : Int?

    func getlikeGalleryAvatarList() -> [String] {
        var avatarList = [String]()
        
        for avatar in likeGallerySliceList! {
            if let imgUrl = avatar.likeSenderProfilePicUrl {
                avatarList.append(imgUrl)
            }
        }
        return avatarList
    }
    
	class func newInstance(map: Map) -> Mappable?{
		return BidAdsRankVoData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		bidAdsRankVos <- map["bidAdsRankVos"]
		bidGalleryUuid <- map["bidGalleryUuid"]
		biddingEndTime <- map["biddingEndTime"]
		biddingStartTime <- map["biddingStartTime"]
		bidsEnd <- map["bidsEnd"]
		bigPicUrl <- map["bigPicUrl"]
		currentVisitorLiked <- map["currentVisitorLiked"]
		hdPicUrl <- map["hdPicUrl"]
		leftDaysHours <- map["leftDaysHours"]
		likeGallerySliceList <- map["likeGallerySliceList"]
		likesCount <- map["likesCount"]
		myBidAmount <- map["myBidAmount"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bidAdsRankVos = aDecoder.decodeObject(forKey: "bidAdsRankVos") as? [BidAdsRankVo]
         bidGalleryUuid = aDecoder.decodeObject(forKey: "bidGalleryUuid") as? String
         biddingEndTime = aDecoder.decodeObject(forKey: "biddingEndTime") as? Int
         biddingStartTime = aDecoder.decodeObject(forKey: "biddingStartTime") as? Int
         bidsEnd = aDecoder.decodeObject(forKey: "bidsEnd") as? Bool
         bigPicUrl = aDecoder.decodeObject(forKey: "bigPicUrl") as? String
         currentVisitorLiked = aDecoder.decodeObject(forKey: "currentVisitorLiked") as? Bool
         hdPicUrl = aDecoder.decodeObject(forKey: "hdPicUrl") as? String
         leftDaysHours = aDecoder.decodeObject(forKey: "leftDaysHours") as? String
         likeGallerySliceList = aDecoder.decodeObject(forKey: "likeGallerySliceList") as? [DisplayOrderPhotoSlice]
         likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
         myBidAmount = aDecoder.decodeObject(forKey: "myBidAmount") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bidAdsRankVos != nil{
			aCoder.encode(bidAdsRankVos, forKey: "bidAdsRankVos")
		}
		if bidGalleryUuid != nil{
			aCoder.encode(bidGalleryUuid, forKey: "bidGalleryUuid")
		}
		if biddingEndTime != nil{
			aCoder.encode(biddingEndTime, forKey: "biddingEndTime")
		}
		if biddingStartTime != nil{
			aCoder.encode(biddingStartTime, forKey: "biddingStartTime")
		}
		if bidsEnd != nil{
			aCoder.encode(bidsEnd, forKey: "bidsEnd")
		}
		if bigPicUrl != nil{
			aCoder.encode(bigPicUrl, forKey: "bigPicUrl")
		}
		if currentVisitorLiked != nil{
			aCoder.encode(currentVisitorLiked, forKey: "currentVisitorLiked")
		}
		if hdPicUrl != nil{
			aCoder.encode(hdPicUrl, forKey: "hdPicUrl")
		}
		if leftDaysHours != nil{
			aCoder.encode(leftDaysHours, forKey: "leftDaysHours")
		}
		if likeGallerySliceList != nil{
			aCoder.encode(likeGallerySliceList, forKey: "likeGallerySliceList")
		}
		if likesCount != nil{
			aCoder.encode(likesCount, forKey: "likesCount")
		}
		if myBidAmount != nil{
			aCoder.encode(myBidAmount, forKey: "myBidAmount")
		}

	}

}
