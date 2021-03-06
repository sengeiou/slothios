//
//  CalculateConstellation.swift
//  SlothChat
//
//  Created by fly on 2016/10/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

extension String{
    func toYMDDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func toYYMMDD() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.date(from: self)
    }
    
    func toYYMMDDHHMMSS() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
}

extension Date{
    
    func toYMDString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func toYYMMDDString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    
    func toYMDHMSString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func toAgeString() -> String {
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return ""
        }
        let oldComponents = calendar.components([.year], from: self)
        let nowComponents = calendar.components([.year], from: Date())

        let oldYear = oldComponents.year!
        let nowYear = nowComponents.year!
        return String(nowYear - oldYear)
    }
    
    func isToday() -> Bool{
        let cal = NSCalendar.current
        let units: Set<Calendar.Component> = [.hour, .day, .month, .year]
        var components = cal.dateComponents(units, from: Date())
        
        let today = cal.date(from: components)
        components = cal.dateComponents(units, from: self)
        let otherDate = cal.date(from: components)
        
        let result = today?.compare(otherDate!)
        return (result == .orderedSame)
    }
    
    func toConstellationString() -> String {
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return ""
        }
        let components = calendar.components([.month, .day], from: self)
        let month = components.month!
        let day = components.day!
        
        
        // 月以100倍之月作为一个数字计算出来
        let mmdd = month * 100 + day;
        var result = ""
        
        if ((mmdd >= 321 && mmdd <= 331) ||
            (mmdd >= 401 && mmdd <= 419)) {
            result = "白羊座"
        } else if ((mmdd >= 420 && mmdd <= 430) ||
            (mmdd >= 501 && mmdd <= 520)) {
            result = "金牛座"
        } else if ((mmdd >= 521 && mmdd <= 531) ||
            (mmdd >= 601 && mmdd <= 621)) {
            result = "双子座"
        } else if ((mmdd >= 622 && mmdd <= 630) ||
            (mmdd >= 701 && mmdd <= 722)) {
            result = "巨蟹座"
        } else if ((mmdd >= 723 && mmdd <= 731) ||
            (mmdd >= 801 && mmdd <= 822)) {
            result = "狮子座"
        } else if ((mmdd >= 823 && mmdd <= 831) ||
            (mmdd >= 901 && mmdd <= 922)) {
            result = "处女座"
        } else if ((mmdd >= 923 && mmdd <= 930) ||
            (mmdd >= 1001 && mmdd <= 1023)) {
            result = "天秤座"
        } else if ((mmdd >= 1024 && mmdd <= 1031) ||
            (mmdd >= 1101 && mmdd <= 1122)) {
            result = "天蝎座"
        } else if ((mmdd >= 1123 && mmdd <= 1130) ||
            (mmdd >= 1201 && mmdd <= 1221)) {
            result = "射手座"
        } else if ((mmdd >= 1222 && mmdd <= 1231) ||
            (mmdd >= 101 && mmdd <= 119)) {
            result = "摩羯座"
        } else if ((mmdd >= 120 && mmdd <= 131) ||
            (mmdd >= 201 && mmdd <= 218)) {
            result = "水瓶座"
        } else if ((mmdd >= 219 && mmdd <= 229) ||
            (mmdd >= 301 && mmdd <= 320)) {
            //考虑到2月闰年有29天的
            result = "双鱼座"
        }else{
            print(mmdd)
            result = "日期错误"
        }
        return result
    }
}

