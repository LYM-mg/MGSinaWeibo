//
//  MGUserAccountModel.swift
//  MGWeibo
//
//  Created by ming on 16/3/25.
//  Copyright © 2016年 ming. All rights reserved.
/*
"access_token" = "2.00ZJgCCDBqyzeE9a2098ff79sdMfyB";
"expires_in" = 157679999;
"remind_in" = 157679999;
uid = 2778589865;
*/

import UIKit

class MGUserAccountModel: NSObject,NSCoding{
    // MARK:- 属性
    var access_token: String?
    var uid: String?
    var screen_name: String?
    var avatar_large: String?
    
    // 过期时间, 单位是秒
    // 如果是自己对自己的应用程序授权, 那么过期时间是差不多5年
    // 如果是其他人对自己的应用程序授权, 那么过期时间是差不多3天
    var expires_in: NSNumber?
    {
        didSet
        {
            if let second = expires_in
            {
                expires_Date = NSDate(timeIntervalSinceNow: second.doubleValue)
            }
        }
    }
    // 真正的过期时间
    var  expires_Date: NSDate?
    
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    // 服务器返回的键值不是一一对应
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description:String {
        let poperty = ["access_token","expires_in","uid","expires_Date","screen_name","avatar_large"]
        let dict = dictionaryWithValuesForKeys(poperty)
        return "\(dict)"
    }
    
    // MARK:- 外部方法
    // MARK:- 存取userAccount
    static let filePath = "useraccount.plist".doc()
    /**
    将授权模型保存到文件中
    */
    // 存储userAccount
    func saveUserAccount() -> Bool
    {
//        MGLog(MGUserAccountModel.filePath)
        return NSKeyedArchiver.archiveRootObject(self, toFile:MGUserAccountModel.filePath)
    }
    // 取出userAccount
//    func getUserAccount() -> Bool
//    {
//         return NSKeyedUnarchiver.unarchiveObjectWithFile(<#T##path: String##String#>)
//    }
    
    
    // MARK:- NSCoding
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeObjectForKey("expires_in") as? NSNumber
        uid = aDecoder.decodeObjectForKey("uid") as? String
        expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeObject(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }

}
