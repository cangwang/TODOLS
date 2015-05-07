import UIKit

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


//获取沙盒路径
func documentsDirectory()->String{
    var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    
    var documentDirectory:String = paths.first as! String
    return documentDirectory
}
//获取数据文件地址
func dataFilePath()->String{
    return documentsDirectory().stringByAppendingString("Todo.plist")
}
class TodoModel: NSObject {
    var id: String
    var image: String
    var title: String
    var date: NSDate
    var detail: String
    var remind:Bool

    //类的构造方法
    init(id:String,image:String,title:String,date:NSDate,detail:String,remind:Bool){
        self.id = id
        self.image = image
        self.title = title
        self.date = date
        self.detail = detail
        self.remind = remind
    }
    

    //从NSObject解析回来
    init(coder aDecoder:NSCoder){
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.image = aDecoder.decodeObjectForKey("image") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        let dateStr = aDecoder.decodeObjectForKey("date") as! String
    
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "MM/dd/yyy,HH/mm"
        let date = dateFormater.dateFromString(dateStr)
        self.date = date!
        
        self.detail = aDecoder.decodeObjectForKey("detail") as! String
        
        self.remind = aDecoder.decodeBoolForKey("remind") as Bool
    }
    
    //编码成NSObject
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(title, forKey: "title")
        let dateStr = stringFromDate(date)
        aCoder.encodeObject(dateStr, forKey: "date")
        aCoder.encodeObject(detail, forKey: "detail")
        aCoder.encodeBool(remind, forKey: "remind")
    }
    
}
