//
//  String+Extension.swift
//  MGWeibo
//
//  Created by ming on 16/3/25.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

extension String
{
    func cache() -> String{
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        return (cachePath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents.last!)
    }
    
    func doc() -> String{
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!
        return (documentPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents
        .last!)
    }
    
    func temp() -> String{
        let tempPath = NSTemporaryDirectory()
        return (tempPath as NSString).stringByAppendingPathComponent((self as NSString).pathComponents
            .last!)
    }
}