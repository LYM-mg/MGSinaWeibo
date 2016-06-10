//
//  MGProgressView.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGProgressView: UIView {
    
    /// 下载进度 0.0~1.0
    var progress: CGFloat = 0.0
    {
        didSet{
            setNeedsDisplay()
        }
    }
    /** 重绘 */
    override func drawRect(rect: CGRect) {
        if progress >= 1.0 || progress < 0.0
        {
            return
        }
        
        // 画圈
        /**
        1.圆心
        2.半径
        3.开始角度
        4.结束角度
        */
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = min(rect.width * 0.5, rect.height * 0.5)
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        
        // 2.创建路径
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 3.连接圆心
        path.addLineToPoint(center)
        
        // 4.关闭路径
        path.closePath()
        UIColor(white: 0.0, alpha: 0.6).setFill()
        path.fill()
    }
}
