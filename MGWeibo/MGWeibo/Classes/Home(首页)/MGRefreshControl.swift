//
//  MGRefreshControl.swift
//  MGWeibo
//
//  Created by ming on 16/4/8.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGRefreshControl: UIRefreshControl {
    // MARK:- 初始化方法
    override init() {
        super.init()
        // 设置子控件
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 重写系统的endRefreshing
    override func endRefreshing() {
        super.endRefreshing()
        showTipFlag = false
        refreshingFlag = false
        refreshView.stopAnimation()
    }
    
    // MARK:- 内部控制方法
    private func setupUI() {
        // 1.添加子控件
        addSubview(refreshView)
        
        // 2.布局子控件
        refreshView.frame.origin.x = (UIScreen.mainScreen().bounds.size.width - refreshView.frame.width) * 0.5
        
        // 3.监听下拉刷新控件frame的改变
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    // MARK:- 监听下拉刷新控件frame的改变
    /// 定义标记记录是否需要旋转
    var showTipFlag: Bool = false
    /// 定义标记记录是否触发了下拉刷新
    var refreshingFlag: Bool = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // 1.过滤垃圾数据
        if frame.origin.y == 0
        {
            return
        }
        
        // 判断是否已经触发事件
        if refreshing && !refreshingFlag { // ture且false
            refreshingFlag = true
            refreshView.tipView.hidden = true
            refreshView.startAnimation()
        }
        
        // 越往下Y越小
        // 越往上Y越大
        
        // 2. 往下拉到一定程度, 箭头需要旋转
        if frame.origin.y < -50 && !showTipFlag { // 箭头往上旋转
            showTipFlag = true
            refreshView.startRotation(showTipFlag)
        }else if frame.origin.y > -50 && showTipFlag{  // 箭头往下旋转
            showTipFlag = false
            refreshView.startRotation(showTipFlag)
        }
    }
    
    // 移除KVO的监听者
    deinit{
        removeObserver(self, forKeyPath: "frame")
    }
    
    // MARK: - 懒加载
    /** 刷新的View */
    private lazy var refreshView: MGRefreshView = MGRefreshView.refreshView()
}

class MGRefreshView: UIView {
    // MARK:- 属性
    /** 菊花视图 */
    @IBOutlet weak var loadingView: UIImageView!
    /** 提示视图 */
    @IBOutlet weak var tipView: UIView!
    /** 箭头视图 */
    @IBOutlet weak var arrowImage: UIImageView!

    // 从xib创建方法
    class func refreshView() -> MGRefreshView {
        return NSBundle.mainBundle().loadNibNamed("MGRefreshView", owner: nil, options: nil).last as! MGRefreshView
    }
    
    // MARK:- 内部控制方法
    /**
    *   执行箭头旋转动画
    */
    func startRotation(flag: Bool) {
        /**
        *   默认：是按照顺时针旋转
        *   原则：就近原则
        */
        var angle = CGFloat(M_PI)
        angle += flag ? -0.001 : +0.001
        UIView.animateWithDuration(0.4) { () -> Void in
            self.arrowImage.transform = CGAffineTransformRotate(self.arrowImage.transform, angle)
        }
    }
    
    /**
    *   执行转盘旋转动画
    */
    func startAnimation(){
        // 1.创建动画对象
        let baseAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        baseAnimation.toValue = 2 * M_PI
        baseAnimation.duration = 2.0
        baseAnimation.repeatCount = MAXFLOAT
        
        // 设置动画不自动移除, 等到view销毁的时候才移除
        baseAnimation.removedOnCompletion = false
        
        // 3.将动画添加到图层上
        loadingView.layer.addAnimation(baseAnimation, forKey: nil)
    }
    
    /**
    *   停止转盘旋转动画
    */
    private func stopAnimation()
    {
        tipView.hidden = false
        loadingView.layer.removeAllAnimations()
    }

    
}