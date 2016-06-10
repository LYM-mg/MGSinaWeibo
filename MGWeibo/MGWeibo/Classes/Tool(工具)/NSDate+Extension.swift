//
//  NSDate+Extension.swift
//  MGWeibo
//
//  Created by ming on 16/4/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

extension NSDate {
    /**
    *  根据字符串转换时间
    */
    class func dateWithString(str: String) -> NSDate? {
        // 1.创建时间格式化对象
        let formatter = NSDateFormatter()
        // 2.指定时间格式
        formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        // 3.指定时区
        formatter.locale = NSLocale(localeIdentifier: "en")
        // 4.转换时间
        return formatter.dateFromString(str)
    }
    
    /**
    *   获取当前时间的格式
    */
    func desStr() -> String{
        // 0.1.创建一个日历类
        let calendar = NSCalendar.currentCalendar()
        
        // 0.2.利用日历类从指定时间从获取指定的组成成分
  
        // 1.1.创建时间格式化对象
        let formatter = NSDateFormatter()

        // 1.2.指定时区
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        if calendar.isDateInToday(self){ // 2.1判断是否是今天
            // 获取当前时间与指定时间的差值
            let res = Int(NSDate().timeIntervalSinceDate(self))
            if res < 60 {
                return "刚刚"
            }else if res < 60 * 60 {
                return "\(res/60)分钟前"
            }else if res < 24 * 60 * 60 {
                return "\(res/(60*60))小时前"
            }
        }else if calendar.isDateInYesterday(self){ // 2.2判断是否是昨天
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.stringFromDate(self)
        }
        
        let comps = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue:0))
        
        if comps.year < 1 { // 2.3一年以内
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.stringFromDate(self)
        }else{ // 2.4更早时间
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.stringFromDate(self)
        }
    }
}
