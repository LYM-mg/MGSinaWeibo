//
//  MGHomeTableViewForwardCell.swift
//  MGWeibo
//
//  Created by ming on 16/4/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import KILabel

class MGHomeTableViewForwardCell: MGHomeTableViewCell {
    override var viewModel: MGStatusViewModel? {
        didSet{
            // 1.设置转发正文
            let name = viewModel?.status?.retweeted_status!.user?.screen_name ?? ""
            
            let text = viewModel?.status?.retweeted_status?.text ?? ""
            
            forwardLabel.attributedText = MGEmoticonPackage.emotionAttributedText("@\(name): " + text)
            
            
            // 2.调整配图位置
            let offset = viewModel?.pictures?.count == 0 ? 0 : 15
            pictureView.snp_updateConstraints { (make) -> Void in
                make.top.equalTo(forwardLabel.snp_bottom).offset(offset)
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1.初始化
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 内部控制方法
    private func setupUI(){
        // 1.添加子控件
        contentView.insertSubview(coverView, belowSubview: pictureView)
        contentView.addSubview(forwardLabel)
        
        // 2.布局子控件
        // 2.1布局蒙板
        coverView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(contentView)
            make.top.equalTo(self.contentTextLabel.snp_bottom).offset(MGMargin)
            make.bottom.equalTo(self.pictureView)
        }
        // 2.2布局转发正文
        forwardLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(coverView).offset(MGMargin)
            make.left.equalTo(contentView).offset(MGMargin)
            make.right.equalTo(contentView).offset(-MGMargin)
        }
        // 2.3更新配图的位置
        pictureView.snp_removeConstraints()
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(forwardLabel)
            make.top.equalTo(forwardLabel.snp_bottom).offset(MGMargin)
        }
    }

    // MARK:- lazy
    /** coverView */
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }()
    
    private lazy var forwardLabel: KILabel = {
        let lb = KILabel()
        lb.numberOfLines = 0
        return lb
    }()
}

