import Foundation

func DateTimeAgoLocalizedStrings(key: String) -> String {
    //  let bundlePath = Bundle.main.bundlePath
    //    + "/NSDateTimeAgo.bundle"
    //    guard let bundle = Bundle(path: bundlePath) else {
    //        return NSLocalizedString(key, comment: "")
    //    }
    return NSLocalizedString(key, comment: "")
    //    return NSLocalizedString(key, tableName: "DateTimeAgo", bundle: bundle, comment: "")
}

func isInTheFuture(date: Date) -> Bool {
    if (date.compare(Date()) == ComparisonResult.orderedDescending) {
        return true
    }
    return false
}

public extension Date {
    var timeAgo: String {
        
        if isInTheFuture(date: self) {
            return DateTimeAgoLocalizedStrings(key: "Just now")
        }
        
        let now = Date()
        let seconds = Int(fabs(timeIntervalSince(now)))
        let minutes = Int(round(Float(seconds) / 60.0))
        let hours = Int(round(Float(minutes) / 60.0))
        
        if seconds < 5 {
            return DateTimeAgoLocalizedStrings(key: "Just now")
        } else if seconds < 60 {
            return stringFromFormat(format: "%%d %@seconds ago", withValue: seconds)
        } else if seconds < 120 {
            return DateTimeAgoLocalizedStrings(key: "A minute ago")
        } else if minutes < 60 {
            return stringFromFormat(format: "%%d %@minutes ago", withValue: minutes)
        } else if minutes < 120 {
            return DateTimeAgoLocalizedStrings(key: "An hour ago")
        } else if hours < 24 {
            return stringFromFormat(format: "%%d %@hours ago", withValue: hours)
        } else if hours < 24 * 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = String(format: "EEEE '%@' HH:mm", DateTimeAgoLocalizedStrings(key: "at"))
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = String(format: "d MMM '%@' HH:mm", DateTimeAgoLocalizedStrings(key: "at"))
            return formatter.string(from: self)
        }
    }
    
    var timeSince: String {
        
        if isInTheFuture(date: self) {
            return DateTimeAgoLocalizedStrings(key: "Now")
        }
        
        let now = Date()
        let seconds = Int(fabs(timeIntervalSince(now)))
        let minutes = Int(round(Float(seconds) / 60.0))
        let hours = Int(round(Float(minutes) / 60.0))
        
        if seconds < 5 {
            return DateTimeAgoLocalizedStrings(key: "Now")
        } else if seconds < 60 {
            return stringFromFormat(format: "%%d %@sec", withValue: seconds)
        } else if minutes < 60 {
            return stringFromFormat(format: "%%d %@min", withValue: minutes)
        } else if hours < 24 {
            return stringFromFormat(format: "%%d %@h", withValue: hours)
        } else if hours < 24 * 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = String(format: "EE HH:mm")
            return formatter.string(from: self)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = String(format: "d MMM HH:mm")
            return formatter.string(from: self)
        }
    }
    
    func stringFromFormat(format: String, withValue value: Int) -> String {
        let localeFormat = String(
            format: format,
            getLocaleFormatUnderscoresWithValue(value: Double(value)))
        
        return String(format: DateTimeAgoLocalizedStrings(key: localeFormat), value)
    }
    
    func getLocaleFormatUnderscoresWithValue(value: Double) -> String {
        let localeCode = NSLocale.preferredLanguages.first!
        
        if localeCode == "ru" {
            let XY = Int(floor(value)) % 100
            let Y = Int(floor(value)) % 10
            
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        return ""
    }
}
