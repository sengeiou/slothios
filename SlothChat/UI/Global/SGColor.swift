//
//  SGColor.swift
//  Chat
//
//  Created by Fly on 16/10/13.
//  Copyright © 2016年 Fly. All rights reserved.
//

import UIKit

class SGColor: NSObject {
    /**
     主题色:#cc966d
     */
    class func SGMainColor() -> UIColor {
        return UIColor.init(red: 204/255.0, green: 150/255.0, blue: 109/255.0, alpha: 1.0)
    }
    /**
     背景灰色:#efeff4
     */
    class func SGBgGrayColor() -> UIColor {
        return UIColor.init(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
    }
    /**
     红:#f7908b
     */
    class func SGRedColor() -> UIColor {
        return UIColor.init(red: 247/255.0, green: 144/255.0, blue: 139/255.0, alpha: 1.0)
    }
    /**
     线条、图案灰色:#ceced2
     */
    class func SGLineColor() -> UIColor {
        return UIColor.init(red: 206/255.0, green: 206/255.0, blue: 210/255.0, alpha: 1.0)
    }
    /**
     蓝:#679cd5
     */
    class func SGBlueColor() -> UIColor {
        return UIColor.init(red: 103/255.0, green: 156/255.0, blue: 213/255.0, alpha: 1.0)
    }
    /**
     文字、链接灰色:#8e8e93
     */
    class func SGTextColor() -> UIColor {
        return UIColor.init(red: 142/255.0, green: 142/255.0, blue: 147/255.0, alpha: 1.0)
    }
}
