//
//  MGPicture.swift
//  MGWeibo
//
//  Created by ming on 16/4/2.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGPicture: NSObject{
    /** 缩列图的URL */
    var thumbnail_URL: NSURL?
    
    /** 大图的URL */
    var large_URL: NSURL?
    
    /** 配图的字符串地址 */
    var thumbnail_pic: String?
    {
        didSet{
            guard let urlStr = thumbnail_pic else {
                return 
            }
            thumbnail_URL = NSURL(string: urlStr)
            
            let temp = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
            large_URL = NSURL(string: temp)
        }
    }
    
    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let peoperty = ["thumbnail_pic"]
        let dict = dictionaryWithValuesForKeys(peoperty)
        return "\(dict)"
    }

}