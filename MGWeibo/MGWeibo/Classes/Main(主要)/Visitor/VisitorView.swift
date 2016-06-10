//
//  VisitorView.swift
//  MGWeibo
//
//  Created by ming on 16/1/8.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

/// 访客视图的一些属性
class VisitorView: UIView {
    // MARK:- 拖线的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- 自定义函数
    class func visitor() ->VisitorView{
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }
    
}
