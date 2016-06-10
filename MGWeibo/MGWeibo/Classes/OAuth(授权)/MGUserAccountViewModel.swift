//
//  MGUserAccountViewModel.swift
//  MGWeibo
//
//  Created by ming on 16/3/26.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGUserAccountViewModel {
    // 用户模型
    var userAccountModel: MGUserAccountModel?
    
    // 单例
    static let shareInstance: MGUserAccountViewModel = MGUserAccountViewModel()
    
    init(){
        loadUserAccount()
    }
    
    /**
    从文件中加载授权
    */
    func loadUserAccount() -> MGUserAccountModel? {
        // 先判断是否已经加载过了
        if userAccountModel != nil
        {
            return userAccountModel
        }
        
        // 从文件中加载
        guard let userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(MGUserAccountModel.filePath) as? MGUserAccountModel else {
           userAccountModel = nil
            return userAccountModel
        }
        
        // 授权过了，判断是否过期
        guard NSDate().compare((userAccount.expires_Date)!) == NSComparisonResult.OrderedAscending else {
           userAccountModel = nil
            return userAccountModel
        }
        
        // 已经授权过了
        userAccountModel = userAccount
        return userAccountModel
    }
    
    /**
    返回用户是否登录
    */
    func isUserLogin() -> Bool
    {
        return loadUserAccount() != nil
    }
    
    /**
    * 根据Code换取AccessToken
    *
    * - parameter code : 已经授权的RequestToken
    * - parameter finidhed: 回调
    */
    func loadAccessTocken(code:String ,finished:(error: NSError?)->()){
        MGNetworkTools.shareInstance.loadAccessToken(code) { (objc, error) -> () in
            // 1.判断
            guard error == nil else {
                finished(error: error)
                return
            }
            
            guard let dict = objc else {
                finished(error: error)
                return
            }
            
            // 2.字典转模型
            let userAccount = MGUserAccountModel(dict: dict)
            
            // 3.获取用户信息
            self.loadUserInfo(userAccount, finished: finished)
        }
    }
    
    /**
    获取用户信息
    
    - parameter code : 已经授权的RequestToken
    - parameter finidhed: 回调
    */
    func loadUserInfo(userAccount: MGUserAccountModel, finished:(error:NSError?)->()){
        MGNetworkTools.shareInstance.loadUserInfo(userAccount) { (objc, error) -> () in
            // 1.判断
            guard error == nil else {
                finished(error: error)
                return
            }

            guard let dict = objc else {
                finished(error: error)
                return
            }
            
            // 2.设置用户信息
            userAccount.screen_name = dict["screen_name"] as? String
            userAccount.avatar_large = dict["avatar_large"] as? String
            
            // 3.保存授权信息
            userAccount.saveUserAccount()
            
            // 4.回调
            finished(error: nil)
        }
    }
}