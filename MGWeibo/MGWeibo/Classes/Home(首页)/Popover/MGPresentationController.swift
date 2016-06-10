//
//  MGPresentationController.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGPresentationController: UIPresentationController {
    
    var presentedFrame = CGRectZero
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
        // 1.设置弹出控制器的尺寸
        setUpPresentedViewFrame()
        
        // 2.添加一个蒙板，点击其他地方，让弹出控制器消失
        addCoverView()
    }
    
    // MARK:-
    func setUpPresentedViewFrame(){
        presentedView()?.frame = presentedFrame
    }
    
    // MARK:- 添加一个蒙板
    private func addCoverView(){
        // 1.创建蒙板
        let coverView = UIView()
        coverView.frame = containerView!.bounds
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        
        // 2.添加手势
        let tap = UITapGestureRecognizer(target: self, action: "coverViewClick")
        coverView.addGestureRecognizer(tap)
        
        // 3.添加蒙板到containView中
        containerView?.insertSubview(coverView, belowSubview: presentedView()!)
    }
    
    // 移除控制器
    @objc private func coverViewClick(){
//        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
        MGLog("coverViewClick")
    }
}
