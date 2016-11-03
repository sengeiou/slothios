//
//	List.swift
//
//	Create by Fly on 31/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class DisplayOrderPhotoSlice : NSObject, NSCoding, Mappable{
    
    var likeSenderProfilePicUrl : String?

    
    class func newInstance(map: Map) -> Mappable?{
        return DisplayOrderPhotoSlice()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        likeSenderProfilePicUrl <- map["likeSenderProfilePicUrl"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        likeSenderProfilePicUrl = aDecoder.decodeObject(forKey: "likeSenderProfilePicUrl") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if likeSenderProfilePicUrl != nil{
            aCoder.encode(likeSenderProfilePicUrl, forKey: "likeSenderProfilePicUrl")
        }
        
    }
    
}
