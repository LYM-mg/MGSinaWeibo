//
//  UIBarButtonItem+Extension.swift
//  Weibo
//
//  Created by ming on 16/3/25.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    /**
    创建item
    
    - parameter imageName: item显示图片
    - parameter target:    谁来监听
    - parameter action:    监听到之后执行的方法
    */
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
}
