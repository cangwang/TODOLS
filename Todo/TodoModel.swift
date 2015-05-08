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
    
    //析构去掉通知
    deinit{
        //删除该任务的消息推送，如果有的话
        let existingNotification = self.notificationForThisItem() as UILocalNotification?
        if existingNotification != nil {
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
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
    
    //发送消息
    func scheduleNotification(){
        
        //通过id获取已有的消息推送，然后删除掉，以便重新判断
        let existingNotification = self.notificationForThisItem() as UILocalNotification?
        
        if existingNotification != nil {
            //取消消息推送
            UIApplication.sharedApplication().cancelLocalNotification(existingNotification!)
        }
        
        //NSComparisonResult.OrderedAscending 表示保存的日期比当前时间较早，即过期了
        //NSOrderedSame 保存的日期和当前时间相同
        println(NSDate())
        if self.remind && self.date.compare(NSDate()) != NSComparisonResult.OrderedAscending{
            //创建UILocalNotificaiton来进行本地消息通知
            var localNotification = UILocalNotification()
            //推送时间
            localNotification.fireDate = self.date
            //设置市区
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            //消息内容
            localNotification.alertBody = self.title
            //声音
            localNotification.soundName = UILocalNotificationDefaultSoundName
            //额外信息
            localNotification.userInfo = ["ID":self.id]
            //发送消息
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            println("主题:\(self.title) 日期:\(self.date)")
        }
    }
    
    func notificationForThisItem()->UILocalNotification?{
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications
        for notification in allNotifications{
            var info:Dictionary<String,String>? = notification.userInfo as? Dictionary
            var idString = info?["ID"]
            if idString != nil && idString == self.id {
                return notification as? UILocalNotification
            }
        }
        return nil
    }
    
}
