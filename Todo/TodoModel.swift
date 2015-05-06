//
//  TodoModel.swift
//  Todo
//
//  Created by air on 15/1/18.
//  Copyright (c) 2015年 air. All rights reserved.
//

import UIKit

class TodoModel: NSObject {
    var id: String
    var image: String
    var title: String
    var date: NSDate
    var detail: String
    var remind:Bool

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
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
        self.detail = aDecoder.decodeObjectForKey("detail") as! String
        
        self.remind = aDecoder.decodeBoolForKey("remind")as Bool
    }
    
    func dateFromString(dateStr:String)->NSDate?{
        let dateFormater = NSDateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH-mm"
        let date = dateFormater.dateFromString(dateStr)
        
        return date
        
    }
    //编码成NSObject
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(detail, forKey: "detail")
        aCoder.encodeBool(remind, forKey: "remind")
    }
    

    
    /*
    func saveTodoItems(){
        var data = NSMutableData()
        //申明一个归档处理对象
        var archiver =  NSKeyedArchiver(forWritingWithMutableData: data)
        //
    }
    */
}
