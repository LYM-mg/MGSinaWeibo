//
//  MGWelcomeViewController.swift
//  MGWeibo
//
//  Created by ming on 16/3/26.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MGWelcomeViewController: UIViewController {
    // MARK:- 控制器的声明周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.初始化界面
        setupUI()
        
        // 2.设置用户头像
        if let urlStr = MGUserAccountViewModel.shareInstance.userAccountModel?.avatar_large {
            iconView.sd_setImageWithURL(NSURL(string: urlStr))
        }
        
        if let userName = MGUserAccountViewModel.shareInstance.userAccountModel?.screen_name {
            tipLabel.text = "\(userName),欢迎回来"
        }
    }
    
    // 做头像从下往上移动动画
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        iconView.snp_updateConstraints { (make) -> Void in
            let offset = -(view.bounds.size.height - 200)
            make.bottom.equalTo(view).offset(offset)
        }
        // 系统的运行循环会在当前运行循环结束的时候同意修改所有约束
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.tipLabel.alpha = 1.0
                }) { (_) -> Void in
                      // 跳转到主界面
                        MGNotificationCenter.postNotificationName(MGSwitchRootViewControllerNotification, object: nil, userInfo: nil)
                   }
        }
    }
    
    // MARK:- lazy
    let bgImageView: UIImageView = {
        let bg = UIImageView()
        bg.image = UIImage(named: "ad_background")
        return bg
    }()
    
    let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = iv.bounds.size.width * 0.5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let tipLabel: UILabel = {
        let tip = UILabel()
        tip.text = "欢迎回来"
        tip.textColor = UIColor.purpleColor()
        tip.alpha = 0.0
        return tip
    }()
    
    // MARK:- 添加子控件
    private func setupUI(){
        // 1.添加子控件
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(tipLabel)
        
        // 2.布局子控件
        bgImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        
        iconView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(90, 90))
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-200)
        }
        
        tipLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(iconView)
            make.top.equalTo(iconView.snp_bottom).offset(20)
        }
    }
}
