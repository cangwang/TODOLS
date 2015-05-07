import UIKit

class DateToString:NSObject{
    //字符串转日期
    func dateFromString(dateStr:String)->NSDate?{
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH-mm"
        let date = dateFormater.dateFromString(dateStr)
        
        return date
        
    }
    //日期转字符串
    func stringFromDate(date:NSDate)->String{
        let locale = NSLocale.currentLocale()
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-MM-dd HH-mm", options: 0, locale: locale)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.stringFromDate(date)
        return dateStr
    }

}