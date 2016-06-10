//
//  MGNetworkTools.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import AFNetworking

class MGNetworkTools: AFHTTPSessionManager{
   
    static let shareInstance : MGNetworkTools = {
        let url = NSURL(string: "https://api.weibo.com/")
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let instance = MGNetworkTools(baseURL: url, sessionConfiguration: configuration)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain","application/json") as? Set
        // 设置请求超时为8秒
        instance.requestSerializer.timeoutInterval = 8.0
        return instance
        }()
    
    // MARK:- 外部控制器的方法
    /**
     *   请求授权accessToken
    
    - parameter code : 已经授权的RequestToken
    - parameter finidhed: 回调
    - parameter error: 错误信息
    */
    func loadAccessToken(code:String, finished: (objc:[String: AnyObject]?, error:NSError?)->()){
        let path = "oauth2/access_token"
        
        // 1.拼接请求参数
        let parameters = ["client_id": App_Key, "client_secret": App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": redirect_uri]
        
        // 2.发送网络请求
       POST(path, parameters: parameters, progress: nil, success: { (_, JSON) -> Void in
            guard let dict = JSON as? [String : AnyObject] else
            {
                finished(objc: nil, error: NSError(domain: "mingmingjiushini", code: 110, userInfo: ["message" : "获取到的授权信息是nil"]))
                return
            }
            // 请求授权成功
            finished(objc: dict, error: nil)
            
            }) { (_, error) -> Void in
                finished(objc: nil, error:error)
        }
    }
    
    /**
    *   获取用户信息
    
    - parameter userAccount : 授权模型
    - parameter finidhed: 回调
    - parameter error: 错误信息
    */
    func loadUserInfo(userAccount: MGUserAccountModel,finished:(objc: [String: AnyObject]?,error: NSError?)->()){
        
        let path = "2/users/show.json"
        let parameters = ["access_token":userAccount.access_token!, "uid":userAccount.uid!]
        GET(path, parameters:parameters, progress: nil, success: { (_, JSON) -> Void in
//            MGLog(JSON)
            // 判断是否成功
            guard let dict = JSON as? [String: AnyObject] else{
                finished(objc: nil, error: NSError(domain: "mingmingjiushini", code: 111, userInfo: ["message" : "获取到的用户信息是nil"]))
                return;
            }
            
            finished(objc: dict, error: nil)
            }) { (_, error) -> Void in
                finished(objc: nil, error: error)
        }
    }
    
    /**
    获取微博数据
    
    - parameter since_id: 用于下拉刷新，返回比指定微博ID大的微博
    - parameter finfished: 回调
    - parameter error:     错误信息
    */
    func loadStauts(since_id: String, max_id: String, finfished: (objc: [[String: AnyObject]]?, error: NSError?)->())
    {
        /**
        since_id: 返回比指定微博ID大的微博（获取最新的微博）
        max_id: 返回小于指定微博ID的微博（获取以前的微博）
        
        注意：如果since_id或者max_id = 0为无效
        */
        
        let path = "2/statuses/home_timeline.json"
        
        // 1.封装请求参数
        let parameters = ["access_token": MGUserAccountViewModel.shareInstance.userAccountModel!.access_token!, "since_id": since_id, "max_id": max_id]
        
        // 2.发送请求
        GET(path, parameters: parameters, progress: nil, success: { (_, JSON) -> Void in
            guard let arr = JSON!["statuses"] as? [[String: AnyObject]] else
            {
                finfished(objc: nil, error: NSError(domain: "mingmingjiushini", code: 112, userInfo: ["message": "获取微博数组出错"]))
                return
            }
            
            // 3.返回数据
            finfished(objc: arr, error: nil)
            }) { (_, error) -> Void in
                finfished(objc: nil, error: error)
        }
    }
    
    /**
    *   发送微博
    
    - parameter status : 微博模型
    - parameter image : 要发布的图片
    - parameter finidhed: 回调
    - parameter error: 错误信息
    */
    func postStatus(status: String,image: UIImage?, finished: (objc: [String: AnyObject]?, error: NSError?)->())
    {
        // 1.封装请求参数
        let parameters = ["access_token": MGUserAccountViewModel.shareInstance.userAccountModel!.access_token!, "status": status]
        var path = "2/statuses/"
        
        if image == nil { // 发文字
            path += "update.json"
            // 2.发送请求
            POST(path, parameters: parameters, progress: nil, success: { (_, JSON) -> Void in
                guard let dict = JSON as? [String: AnyObject] else
                {
                    finished(objc: nil, error: NSError(domain: "mingmingjiushini", code: 115, userInfo: ["message" : "服务器没有返回已经发送的微博数据"]))
                    return
                }
                finished(objc: dict, error: nil)
                
                }) { (_, error) -> Void in
                    finished(objc: nil, error: error)
            }
        }else { // 发图文
            path += "upload.json"
            // 2.发送请求
            POST(path, parameters: parameters, constructingBodyWithBlock: { (formData) -> Void in
                let data = UIImagePNGRepresentation(image!)!
                formData.appendPartWithFileData(data, name: "pic", fileName: "ming.abc", mimeType: "image/*")
                }, success: { (_, JSON) -> Void in
                    guard let dict = JSON as? [String: AnyObject] else
                    {
                        finished(objc: nil, error: NSError(domain: "mingmingjiushini", code: 116, userInfo: ["message" : "服务器没有返回已经发送带图片的微博数据"]))
                        return
                    }
                    finished(objc: dict, error: nil)
                }) { (_, error) -> Void in
                    finished(objc: nil, error: error)
            }
        }
    }
}

