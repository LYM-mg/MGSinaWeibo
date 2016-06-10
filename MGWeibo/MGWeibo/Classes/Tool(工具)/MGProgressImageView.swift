//
//  MGProgressImageView.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGProgressImageView: UIImageView {
    /// 下载进度 0.0~1.0
    var progress: CGFloat = 0.0
        {
        didSet{
            progressView.progress = progress
        }
    }
    
    init(){
        super.init(frame: CGRectZero)
        addSubview(self.progressView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.frame = bounds
    }
    
    private lazy var progressView: MGProgressView = {
        let pv = MGProgressView()
        pv.backgroundColor = UIColor.clearColor()
        return pv
    }()
}
