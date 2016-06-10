//
//  MGProfileViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGProfileViewController: MGBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin { // 没有登录就要执行{}内的代码
            setUpVisitorInfo("这是我的界面", iconName: "visitordiscover_image_profile") 
        }

    }

    

}
