//
//  MGDiscoverViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGDiscoverViewController: MGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin { // 没有登录就要执行{}内的代码
            setUpVisitorInfo("这是发现界面", iconName: "visitordiscover_image_message")
        }
        
    }
}
