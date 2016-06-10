//
//  MGBaseViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/8.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGBaseViewController: UITableViewController {
    // MARK:- 属性
    /// 记录是否有登录
    var isLogin : Bool = MGUserAccountViewModel.shareInstance.isUserLogin()
    
    /// 保存访客视图
    var visitorView : VisitorView?
    
    // MARK:- 系统回调的函数
    override func loadView() {
        // 决定是否显示访客视图界面
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK:- 自定义的函数
    /// 初始化访客视图hkjhjkj
    private func setupVisitorView() {
        // 1.创建访客视图
        let visitorView = VisitorView.visitor()
        
        // 2.监听访客视图按钮的点击
        visitorView.registButton.addTarget(self, action: "registButtonClick", forControlEvents: .TouchUpInside)
        visitorView.loginButton.addTarget(self, action: "loginButtonClick", forControlEvents: .TouchUpInside)
        
        // 3.在NavigationBar左右两边添加item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Done, target: self, action: "registButtonClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Done, target: self, action: "loginButtonClick")
        
        // 4.设置访客视图
        self.visitorView = visitorView;
        // 控制器的View是访客视图
        view = visitorView;
    }
    
    /**
    *   初始化访客视图 并且修改访客视图的一些属性
    *   title: 用来显示一些文字
    *   iconName: 图标照片的名字
    */
    func setUpVisitorInfo(title : String, iconName : String) {
        visitorView?.titleLabel.text = title // 显示文字
        visitorView?.iconView.image = UIImage(named: iconName) // 图标照片名字
        visitorView?.rotationView.hidden = true // 隐藏转盘view
    }
    
    /// 转盘View的转动动画
    func startAnimationRotation() {
        // 1.创建基本动画
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画属性
        baseAnimation.fromValue = 0;
        baseAnimation.toValue = M_PI * 2
        baseAnimation.duration = 10
        baseAnimation.repeatCount = MAXFLOAT
        
        // 默认情况下:true
        // true:表示界面消失重新回来,那么动画会消失
        // false:表示界面消失重新回来,那么动画不会消失
        baseAnimation.removedOnCompletion = false
        
        // 3.添加动画
        visitorView?.rotationView.layer .addAnimation(baseAnimation, forKey: nil)
    }
    
    // MARK:- 监听方法
    /// 注册按钮的点击
    @objc private func registButtonClick() {
        print("registButtonClick")
    }
    
    /// 登录按钮的点击
    @objc private func loginButtonClick() {
        let OAuthVc = MGOAuthViewController()
        let navVc = UINavigationController(rootViewController: OAuthVc)
        presentViewController(navVc, animated: true, completion: nil)
    }
    
    
}
