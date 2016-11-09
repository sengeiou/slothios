//
//  LocationManager.swift
//  SlothChat
//
//  Created by fly on 2016/11/5.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import CoreLocation



class LocationManager: NSObject,CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    func startLocationCity() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if (authorizationStatus == CLAuthorizationStatus.notDetermined){
            manager.requestWhenInUseAuthorization()
        } else {
            manager.startUpdatingLocation()
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.delegate = self
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
        let location = locations.last
        if location == nil {
            return
        }
        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    SGLog(message: error?.localizedDescription)
                }
                if let mark = placemarks?.first{
                    SGLog(message: mark.locality)
                    //城市
//                    let city: String = (mark.addressDictionary! as NSDictionary).value(forKey:"City") as! String
                    //国家
//                    let country: String = (mark.addressDictionary! as NSDictionary).value(forKey:"Country") as! String
                    //国家编码
//                    let CountryCode: String = (mark.addressDictionary! as NSDictionary).value(forKey:"CountryCode") as! String
                    //街道位置
//                    let FormattedAddressLines: String = ((mark.addressDictionary! as NSDictionary).value(forKey:"FormattedAddressLines") as AnyObject).firstObject as! String
                    //具体位置
                    let Name: String = (mark.addressDictionary! as NSDictionary).value(forKey:"Name") as! String
//                    //省
//                    var State: String = (mark.addressDictionary! as NSDictionary).value(forKey:"State") as! String
//                    //区
//                    let SubLocality: String = (mark.addressDictionary! as NSDictionary).value(forKey:"SubLocality") as! String
//                    
//                    
//                    //如果需要去掉“市”和“省”字眼
//                    
//                    State = State.replacingOccurrences(of: "省", with: "")
//                    let citynameStr = city.replacingOccurrences(of: "市", with: "")
//                    
//                    let desc = country + State + citynameStr + SubLocality + Name
                    
                    GVUserDefaults.standard().locationDesc = Name
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SGLog(message: error.localizedDescription)
    }
    
}

//extension NSObject,{
//    func startLocationCity() {
//        manager.delegate = self
//        
//    }
//}
