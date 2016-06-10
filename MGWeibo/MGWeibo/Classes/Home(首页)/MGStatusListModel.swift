//
//  MGStatusListModel.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SDWebImage

// MARK:- MGStatusListModel
class MGStatusListModel: NSObject {
    /// 创建微博数据源数组
    var statusList: [MGStatusViewModel]?
    /// 创建微博数临时据源数组(提示有多少条微博)
//    var tempViewmodels = [MGStatusViewModel]()
    
    // MARK:- 加载微博数据/加载最新微博数据
    func loadData(pullUpFlag: Bool, finished:(error: NSError?,[MGStatusViewModel]?) -> ()) {
        // 1.获取第一条微博的since_id
        var since_id = statusList?.first?.status?.idstr ?? "0"
        var max_id = "0"
        
        if pullUpFlag {
            since_id = "0"
            if let temp = statusList?.last?.status?.idstr {
                max_id = "\(Int(temp)! - 1)"
            }
        }
        
        // 2.从本地加载数据
        loadStatus(since_id, max_id: max_id) { (models) -> () in
            if !models.isEmpty {
                if Int(since_id) > 0 {
                    // 将最新的数据拼接到最前面
                    self.statusList = models + self.statusList!
                }else if Int(max_id) > 0 {
                    // 将最新的数据拼接到最前面
                    self.statusList = self.statusList! + models
                }else {
                    self.statusList = models
                }
                finished(error: nil,  self.statusList)
                return
            }
            
            // 3.从网络加载数据
            self.loadStatusFromNetwork(since_id, max_id: max_id, finished: finished)
        }
    }
    
    //MARK:- 从网络加载数据
    private func loadStatusFromNetwork(since_id: String, max_id: String,finished:(error: NSError?,[MGStatusViewModel]?) -> ()){
        // 3.发送网络请求数据
        MGNetworkTools.shareInstance.loadStauts(since_id, max_id: max_id) { (objc, error) -> () in
            guard error == nil else
            {
                finished(error: error, nil)
                return
            }
            // MGLog(MGUserAccountModel.filePath)
            guard let dictArr = objc else {
                finished(error: NSError(domain: "mingmingjiushini", code: 111, userInfo: ["message" : "获取微博数据失败"]), nil)
                return
            }
            
            // 缓存微博数据
            self.cacheStatus(dictArr)
            
            var viewmodels = [MGStatusViewModel]()
            for dict in dictArr {
                viewmodels.append(MGStatusViewModel(status: MGStatus(dict: dict)))
            }
//            self.tempViewmodels = viewmodels
            
            if Int(since_id) > 0 {
                // 将最新的数据拼接到最前面
                self.statusList = viewmodels + self.statusList!
            } else if Int(max_id) > 0 {
                // 将最新的数据拼接到最前面
                self.statusList = self.statusList! + viewmodels
            }else {
                self.statusList = viewmodels
            }
            
            // 缓存配图(目的: 将来能够拿到图片的大小, 按照图片的宽高比进行显示)
            self.cacheImages(viewmodels, finished: finished)
        }
    }
    
    // MARK:- 从数据库读取微博
    /**
    读取微博数据
    
    - parasmeter array: 微博数组
    */
    func loadStatus(since_id: String, max_id: String, finished:([MGStatusViewModel]) -> ()){
        let userId = MGUserAccountViewModel.shareInstance.userAccountModel!.uid!
        
        var sql = "SELECT * FROM T_Status WHERE userId == '\(userId)'"
        
        if Int64(since_id) > 0{
            sql += "AND statusId > '\(since_id)'"
        } else if Int64(max_id) > 0{
             sql += "AND statusId <= '\(since_id)'"
        }
        sql += "ORDER BY StatusId DESC \n"
        sql += "LIMIT 20"
        
        // 3.执行SQL语句
        var statusArray = [MGStatusViewModel]()
        SQLiteManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
            let result = db.executeQuery(sql, withArgumentsInArray: nil)
            while result.next() {
                // 1.取出数据库存储的微博字典
                let statusText = result.stringForColumn("statusText")
                // 2.将字符串转成data
                let data = statusText.dataUsingEncoding(NSUTF8StringEncoding)
            
                let dict = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
                let viewModel = MGStatusViewModel(status: MGStatus(dict: dict))
                statusArray.append(viewModel)
            }
        })
        finished(statusArray)
    }
    
    // MARK:- 缓存微博
    /**
    缓存微博数据
    
    - parameter array: 微博数组
    */
    private func cacheStatus(array: [[String: AnyObject]]){
        
        // 1.取得用户ID
        let userId = MGUserAccountViewModel.shareInstance.userAccountModel!.uid!
        // 执行SQL语句,插入数据
        SQLiteManager.shareInstance.dbQueue?.inTransaction({ (db, rollback) -> Void in
            for dict in array {
                // 取得微博ID
                let statusId = dict["idstr"]!
                
                // 取得微博正文
                let data = try!  NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted)
                let statusText = String(data: data, encoding: NSUTF8StringEncoding)!
                
                // SQL语句
                let sql = "INSERT INTO T_Status \n" +
                    "(statusId,statusText,userId) \n" +
                    "VALUES \n" +
                "( ?, ? , ?);"
                
                if !db.executeUpdate(sql, withArgumentsInArray: [statusId,statusText,userId]) {
                    rollback.memory = true
                }
            }
        })
    }

    
    // MARK:- 缓存图片
    private func cacheImages(models: [MGStatusViewModel],finished:(error: NSError?,[MGStatusViewModel]?) -> ()){
        // 1.创建组
        let group = dispatch_group_create()
        
        for viewModel in models {
            guard let pictures = viewModel.pictures else {
                continue
            }
            // 2.下载图片
            for picture in pictures {
                // 进入组
                dispatch_group_enter(group)
                SDWebImageManager.sharedManager().downloadImageWithURL(picture.thumbnail_URL, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, error, _, _, _) -> Void in
                    // 离开组
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 3.监听图片是否全部下载完成
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 获取数据源并刷新数据
            finished(error: nil, models)
        }
    }
    
    // MARK:- 缓存微博
    /**
    *  清除缓存微博数据(5天前的微博数据)
    */
     class func clearStatus(){
        // 1.获取5天前的时间
        let date = NSDate(timeIntervalSinceNow: -24 * 60 * 60 * 5)
    
        // 2.创建formatter对象
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        // 3.将date对象类型转成String类型
        let time = formatter.stringFromDate(date)
        
        // 4.插入SQL语句
        let sql = "DELETE FROM T_Status WHERE creatTime <= '\(time)';"
        
        // 5.执行SQL语句
        SQLiteManager.shareInstance.dbQueue?.inDatabase({ (db) -> Void in
            db.executeUpdate(sql, withArgumentsInArray: nil)
        })
        
    }
}
