//
//  MGMainController.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGMainController: UITabBarController {
    // MARK:- 懒加载
    /// item的图片数组
    lazy var imageNames : [String] = {
        return ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
    }()
    
    /// 发布按钮
    lazy var composeBtn : MGButton = {
        let composeBtn = MGButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
        
        // 设置位置
        composeBtn.center = CGPoint(x: self.tabBar.center.x, y: self.tabBar.bounds.size.height*0.5)
        
        // 添加按钮监听
        composeBtn.addTarget(self, action: "composeBtnClick", forControlEvents: .TouchUpInside)
        
        return composeBtn
    }()
    
    // MARK:- 出初始化操作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加中间发布按钮
        tabBar.addSubview(composeBtn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        adjustItems()
    }
    
    // MARK:- 自定义函数
    private func adjustItems() {
        for i in 0..<tabBar.items!.count {
            let item = tabBar.items![i]
            
            if i == 2 {
                item.enabled = false
                continue
            }
            
            // 设置照片
            item.image = UIImage(named:imageNames[i])
            item.selectedImage = UIImage(named: imageNames[i] + "_Highlighted")
        }
    }
    
    
    // MARK:- 监听操作
    // 点击发布按钮
    @objc private func composeBtnClick() {
        let composeVc = MGComposeViewController()
        let nav = UINavigationController(rootViewController: composeVc)
        presentViewController(nav, animated: true, completion: nil)
    }
}
