//
//  MGHomeTableViewCell.swift
//  MGWeibo
//
//  Created by ming on 16/3/31.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import KILabel

enum MGHomeTableViewCellIdentifier: String{
    case NormalCellIdentifier = "NormalIdentifier"
    case ForwardCellIdentifier = "ForwardIdentifier"
    
    /**
    * 根据模型viewModel返回对应的标识符
    */
    static func cellWithViewModel(viewModel: MGStatusViewModel?) -> String {
        return viewModel!.status?.retweeted_status != nil ? ForwardCellIdentifier.rawValue : NormalCellIdentifier.rawValue
    }
}

class MGHomeTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // 1.设置UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** viewModel */
    var viewModel: MGStatusViewModel?
    {
        didSet{
            // 1.给头部视图设置数据
            topView.viewModel = viewModel
            
            // 2..设置正文
            contentTextLabel.attributedText = MGEmoticonPackage.emotionAttributedText(viewModel?.status?.text ?? "")
            
            // 3.给配图设置数据
            pictureView.viewModel = viewModel
            
            // 4.给底部视图设置数据
        }
    }
    
    // MARK:- 1.设置UI
    private func setupUI() {
        
        // 1.添加子控件
        // 1.1添加头部视图
        contentView.addSubview(topView)
        // 1.2添加正文视图
        contentView.addSubview(contentTextLabel)
        // 1.3添加配图视图
        contentView.addSubview(pictureView)
        // 1.4添加底部视图
        contentView.addSubview(bottomView)
        
        
        // 2.布局子控件
        // 2.1头部视图约束
        topView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(contentView)
        }
        // 2.2文字约束
        contentTextLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topView.snp_bottom).offset(15)
            make.left.equalTo(topView).offset(15)
            make.width.equalTo(UIScreen.mainScreen().bounds.size.width - 2*15)
        }
        // 2.3配图约束
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(contentTextLabel)
            make.top.equalTo(contentTextLabel.snp_bottom).offset(15)
        }
        // 2.4底部视图约束
        bottomView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(contentView)
            make.height.equalTo(44.0)
            make.top.equalTo(pictureView.snp_bottom).offset(15)
        }
    }
    
    // MARK:- 计算行高
    func rowHeight(viewModel: MGStatusViewModel) -> CGFloat{
        // 1.给属性赋值
        self.viewModel = viewModel
        
        // 2.更新布局
        layoutIfNeeded()
        
        // 3.返回cell行高
        return CGRectGetMaxY(bottomView.frame)
    }
    
    // MARK:- lazy懒加载
    /** 顶部视图 */
    private lazy var topView: MGHomeCellTopView = MGHomeCellTopView()
    
    /** 正文 */
    lazy var contentTextLabel: KILabel = {
        let lb = KILabel()
        lb.numberOfLines = 0
        lb.urlLinkTapHandler = {
            (label, url, range)  in
            MGLog(url)
        }
        lb.userHandleLinkTapHandler = { label, handle, range in
             MGLog("User handle \(handle) tapped")
        }
        return lb
    }()
    
    /** 配图 */
    lazy var pictureView: MGHomePictureView = MGHomePictureView()
    
    /** 底部视图view */
    lazy var bottomView: MGHomeCellBottomView = MGHomeCellBottomView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
