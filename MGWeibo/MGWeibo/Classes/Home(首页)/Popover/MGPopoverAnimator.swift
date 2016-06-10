//
//  MGPopoverAnimator.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGPopoverAnimator: NSObject {
    var presentedFrame = CGRectZero
}

extension MGPopoverAnimator:UIViewControllerTransitioningDelegate{
    // 1.当弹出一个控制器时会调用该方法
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = MGPresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentationController.presentedFrame = presentedFrame
        return presentationController
    }
    
    // 2.设置自定义动画
    // 2.1出现动画
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 发布通知
        NSNotificationCenter.defaultCenter().postNotificationName(MGPopoverPresentedNotification, object: nil)
        return self
    }
    // 2.2消失动画
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // 发布通知
        NSNotificationCenter.defaultCenter().postNotificationName(MGPopoverDismissNotification, object: nil)
        return self
    }
}

extension MGPopoverAnimator:UIViewControllerAnimatedTransitioning{
    /// 该方法是告知系统动画的时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    /// 该方法是告诉系统动画如何执行
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        // 1.取得要弹出的View,表示是弹出动画
        if let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        {
            // 2.将弹出的view添加到容器视图中
            transitionContext.containerView()?.addSubview(toView)
            
            // 3.给弹出的View做一个动画
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            toView.layer.anchorPoint = CGPointMake(0.5, 0)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                toView.transform = CGAffineTransformIdentity
                }, completion: { (isFinished) -> Void in
                    transitionContext.completeTransition(true)
            })
        }else{ // 没有取得弹出的View，表示是消失的动画
            // 1.取得要消失的view
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            
            // 2.给消失的View做一个动画
            fromView.layer.anchorPoint = CGPointMake(0.5, 0)
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                fromView.transform = CGAffineTransformMakeScale(1.0,0)
                }, completion: { (isFinished) -> Void in
                    transitionContext.completeTransition(true)
                    fromView.removeFromSuperview()
            })
        }
    }
    
}