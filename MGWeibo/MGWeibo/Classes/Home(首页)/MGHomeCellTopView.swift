//
//  MGHomeCellTopView.swift
//  MGWeibo
//
//  Created by ming on 16/4/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGHomeCellTopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // MARK:- 1.设置UI
    private func setupUI(){
        // 1.添加子控件
        addSubview(iconView)
        addSubview(verfiedView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        
        // 2.布局子控件
        iconView.snp_makeConstraints { (make) -> Void in
            make.left.top.equalTo(self).offset(15)
            make.bottom.equalTo(self.snp_bottom)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        verfiedView.snp_makeConstraints { (make) -> Void in
            make.right.bottom.equalTo(iconView)
        }
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(iconView).offset(5)
            make.left.equalTo(iconView.snp_right).offset(15)
        }
        vipView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp_right).offset(15)
        }
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(iconView).offset((-5))
            make.left.equalTo(nameLabel)
        }
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp_right).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** viewModel */
    var viewModel: MGStatusViewModel?
        {
        didSet{
            // 1.设置头像
            iconView.sd_setImageWithURL(viewModel?.iconURL)
            // 2.设置认证用户
            verfiedView.image = viewModel?.verifiedImage
            // 3.设置昵称
            nameLabel.text = viewModel?.status?.user?.screen_name ?? ""
            // 4.设置会员图标
            vipView.image = viewModel?.vipImage
            // 5.设置时间
            timeLabel.text = viewModel?.timeText
            // 6.设置来源
            sourceLabel.text = viewModel?.sourceText
        }
    }
    
    // MARK:- lazy懒加载
    // MARK:- 顶部视图
    /** 头像 */
    private lazy var iconView:UIImageView = {
        let iconView = UIImageView(image: UIImage(named: "avatar_default_big"))
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        return iconView
        }()
    /** 认证头标 */
    private lazy var verfiedView:UIImageView  = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    /** 昵称 */
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
        }()
    /** 会员图标 */
    private lazy var vipView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    /** 时间 */
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        return timeLabel
        }()
    /** 来源 */
    private lazy var sourceLabel: UILabel = {
        let sourceLabel = UILabel()
        sourceLabel.textColor = UIColor.darkGrayColor()
        return sourceLabel
        }()
}
