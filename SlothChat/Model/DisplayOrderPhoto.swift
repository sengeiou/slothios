//
//	List.swift
//
//	Create by Fly on 31/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class DisplayOrderPhoto : NSObject, NSCoding, Mappable{

	var adress : String?
	var adsImpressionOrderNum : Int?
	var bigPicUrl : String?
	var currentVisitorLiked : Bool?
    var displayAsBidAds : Bool?
	var hdPicUrl : String?
	var likeGallerySliceList : [DisplayOrderPhotoSlice]?
	var likesCount : Int?
	var memo : String?
	var nickname : String?
	var profilePicUrl : String?
	var smallPicUrl : String?
	var userUuid : String?
	var uuid : String?

	class func newInstance(map: Map) -> Mappable?{
		return DisplayOrderPhoto()
	}
	required init?(map: Map){}
	private override init(){}
    
    func getLikeGallerySliceUrlList() -> [String] {
        var urlList = [String]()
        
        for photo in self.likeGallerySliceList! {
            if (photo.likeSenderProfilePicUrl != nil) {
                urlList.append(photo.likeSenderProfilePicUrl!)
            }
        }
        
        return urlList
    }

	func mapping(map: Map)
	{
		adress <- map["adress"]
		adsImpressionOrderNum <- map["adsImpressionOrderNum"]
		bigPicUrl <- map["bigPicUrl"]
		currentVisitorLiked <- map["currentVisitorLiked"]
        displayAsBidAds <- map["displayAsBidAds"]
		hdPicUrl <- map["hdPicUrl"]
		likeGallerySliceList <- map["likeGallerySliceList"]
		likesCount <- map["likesCount"]
		memo <- map["memo"]
		nickname <- map["nickname"]
		profilePicUrl <- map["profilePicUrl"]
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
         currentVisitorLiked = aDecoder.decodeObject(forKey: "currentVisitorLiked") as? Bool
         displayAsBidAds = aDecoder.decodeObject(forKey: "displayAsBidAds") as? Bool
         hdPicUrl = aDecoder.decodeObject(forKey: "hdPicUrl") as? String
         likeGallerySliceList = aDecoder.decodeObject(forKey: "likeGallerySliceList") as? [DisplayOrderPhotoSlice]
         likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
         memo = aDecoder.decodeObject(forKey: "memo") as? String
         nickname = aDecoder.decodeObject(forKey: "nickname") as? String
         profilePicUrl = aDecoder.decodeObject(forKey: "profilePicUrl") as? String
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
		if currentVisitorLiked != nil{
			aCoder.encode(currentVisitorLiked, forKey: "currentVisitorLiked")
		}
        if displayAsBidAds != nil{
            aCoder.encode(displayAsBidAds, forKey: "displayAsBidAds")
        }
		if hdPicUrl != nil{
			aCoder.encode(hdPicUrl, forKey: "hdPicUrl")
		}
		if likeGallerySliceList != nil{
			aCoder.encode(likeGallerySliceList, forKey: "likeGallerySliceList")
		}
		if likesCount != nil{
			aCoder.encode(likesCount, forKey: "likesCount")
		}
		if memo != nil{
			aCoder.encode(memo, forKey: "memo")
		}
		if nickname != nil{
			aCoder.encode(nickname, forKey: "nickname")
		}
		if profilePicUrl != nil{
			aCoder.encode(profilePicUrl, forKey: "profilePicUrl")
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
