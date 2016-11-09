//
//	RootClass.swift
//
//	Create by Fly on 6/11/2016
//	Copyright © 2016 guahao. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class UserGalleryPhoto : NSObject, NSCoding, Mappable{
    
    var adress : String?
    var adsImpressionOrderNum : Int?
    var bigPicLocalPath : String?
    var bigPicUrl : String?
    var createdTime : Int?
    var displayAsBidAds : Bool?
    var hdPicUrl : String?
    var isPublic : Bool?
    var isRemoved : Bool?
    var latlong : AnyObject?
    var likesCount : Int?
    var memo : String?
    var participateBidAds : Bool?
    var smallPicLocalPath : String?
    var smallPicUrl : String?
    var updateTime : Int?
    var userUuid : String?
    var uuid : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return UserGalleryPhoto()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        adress <- map["adress"]
        adsImpressionOrderNum <- map["adsImpressionOrderNum"]
        bigPicLocalPath <- map["bigPicLocalPath"]
        bigPicUrl <- map["bigPicUrl"]
        createdTime <- map["createdTime"]
        displayAsBidAds <- map["displayAsBidAds"]
        hdPicUrl <- map["hdPicUrl"]
        isPublic <- map["isPublic"]
        isRemoved <- map["isRemoved"]
        latlong <- map["latlong"]
        likesCount <- map["likesCount"]
        memo <- map["memo"]
        participateBidAds <- map["participateBidAds"]
        smallPicLocalPath <- map["smallPicLocalPath"]
        smallPicUrl <- map["smallPicUrl"]
        updateTime <- map["updateTime"]
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
        bigPicLocalPath = aDecoder.decodeObject(forKey: "bigPicLocalPath") as? String
        bigPicUrl = aDecoder.decodeObject(forKey: "bigPicUrl") as? String
        createdTime = aDecoder.decodeObject(forKey: "createdTime") as? Int
        displayAsBidAds = aDecoder.decodeObject(forKey: "displayAsBidAds") as? Bool
        hdPicUrl = aDecoder.decodeObject(forKey: "hdPicUrl") as? String
        isPublic = aDecoder.decodeObject(forKey: "isPublic") as? Bool
        isRemoved = aDecoder.decodeObject(forKey: "isRemoved") as? Bool
        latlong = aDecoder.decodeObject(forKey: "latlong") as? AnyObject
        likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
        memo = aDecoder.decodeObject(forKey: "memo") as? String
        participateBidAds = aDecoder.decodeObject(forKey: "participateBidAds") as? Bool
        smallPicLocalPath = aDecoder.decodeObject(forKey: "smallPicLocalPath") as? String
        smallPicUrl = aDecoder.decodeObject(forKey: "smallPicUrl") as? String
        updateTime = aDecoder.decodeObject(forKey: "updateTime") as? Int
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
        if bigPicLocalPath != nil{
            aCoder.encode(bigPicLocalPath, forKey: "bigPicLocalPath")
        }
        if bigPicUrl != nil{
            aCoder.encode(bigPicUrl, forKey: "bigPicUrl")
        }
        if createdTime != nil{
            aCoder.encode(createdTime, forKey: "createdTime")
        }
        if displayAsBidAds != nil{
            aCoder.encode(displayAsBidAds, forKey: "displayAsBidAds")
        }
        if hdPicUrl != nil{
            aCoder.encode(hdPicUrl, forKey: "hdPicUrl")
        }
        if isPublic != nil{
            aCoder.encode(isPublic, forKey: "isPublic")
        }
        if isRemoved != nil{
            aCoder.encode(isRemoved, forKey: "isRemoved")
        }
        if latlong != nil{
            aCoder.encode(latlong, forKey: "latlong")
        }
        if likesCount != nil{
            aCoder.encode(likesCount, forKey: "likesCount")
        }
        if memo != nil{
            aCoder.encode(memo, forKey: "memo")
        }
        if participateBidAds != nil{
            aCoder.encode(participateBidAds, forKey: "participateBidAds")
        }
        if smallPicLocalPath != nil{
            aCoder.encode(smallPicLocalPath, forKey: "smallPicLocalPath")
        }
        if smallPicUrl != nil{
            aCoder.encode(smallPicUrl, forKey: "smallPicUrl")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if userUuid != nil{
            aCoder.encode(userUuid, forKey: "userUuid")
        }
        if uuid != nil{
            aCoder.encode(uuid, forKey: "uuid")
        }
        
    }
    
}
