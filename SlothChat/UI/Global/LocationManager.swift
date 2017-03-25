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
        
        if self.requestAuthorization() {
            manager.requestWhenInUseAuthorization()
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.delegate = self
            manager.requestLocation();
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        
        let location = locations.last
        if location == nil {
            return
        }
        
        SGLog(message: location)
        
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
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        SGLog(message: error)
    }
    
    func requestAuthorization() -> Bool {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        // If the status is denied or only granted for when in use, display an alert
        if status == .denied {
            GVUserDefaults.standard().locationDesc = "";
            var title: String
            title = "无法定位"
            let message: String = "定位已关闭,请在设置-隐私里打开"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(cancelAction)
            let settingAction = UIAlertAction(title: "设置", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.shared.openURL(settingsURL!)
                })
            })
            alert.addAction(settingAction)
            let vc: UIViewController? = appDelegate?.window?.rootViewController
            vc?.present(alert, animated: true, completion: { _ in })
        }
        if status == .restricted {
            GVUserDefaults.standard().locationDesc = "";
            return false
        }
        else {
            return true
        }
    }
    
}

//extension NSObject,{
//    func startLocationCity() {
//        manager.delegate = self
//        
//    }
//}
