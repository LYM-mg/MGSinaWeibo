//
//  TitleButton.swift
//  MGWeibo
//
//  Created by ming on 16/1/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    // 如果在控件中重写init(frame: CGRect)函数,必须重写init(coder : NSCoder)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("mg的微博", forState: .Normal)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        
        sizeToFit()
    }
    
    // 如果在控件中重写init(frame: CGRect)函数,必须重写init(coder : NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Swift中可以直接修改对象中的结构内部的属性
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
    }

}
