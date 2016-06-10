//
//  MGButton.swift
//  MGWeibo
//
//  Created by ming on 16/1/8.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGButton: UIButton {
    
    /// 遍历构造函数
    convenience init(imageName:String, bgImageName:String){
        self.init()
        
        // 1.设置按钮的属性
        // 1.1图片
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        
        // 1.2背景
        setBackgroundImage(UIImage(named: bgImageName), forState: .Normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), forState: .Highlighted)
        
        // 2.设置尺寸
        sizeToFit()
    }
    
    convenience init(imageName:String, target:AnyObject, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        sizeToFit()
        
        // 2.监听
        addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    convenience init(title:String, target:AnyObject, action:Selector) {
        self.init()
        // 1.设置按钮的属性
        setTitle(title, forState: UIControlState.Normal)
        sizeToFit()
        
//        backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        // 2.监听
        addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    convenience init(imageName:String, title: String, target:AnyObject, action:Selector) {
        self.init()
        
        // 1.设置按钮的属性
        setImage(UIImage(named: imageName), forState: .Normal)
//        setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        setTitle(title, forState: UIControlState.Normal)
        imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        titleEdgeInsets  = UIEdgeInsetsMake(0, 5, 0, 0)
        titleLabel?.font = UIFont.systemFontOfSize(14)
        setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        
        // 2.监听
        addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
}
