//
//  MGMessageViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGMessageViewController: MGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin { // 没有登录,就要执行{}内的代码
            setUpVisitorInfo("这是消息界面", iconName: "visitordiscover_image_message")
        }
        
    }
}
