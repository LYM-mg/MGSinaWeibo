//
//  MGHomeCellswift
//  MGWeibo
//
//  Created by ming on 16/4/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGHomeCellBottomView: UIView {
    // MARK:- 系统方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 250.0/255.0, alpha: 0.7)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 内部控制方法
    private func setupUI(){
        // 1.添加子控件
        addSubview(retweetButton)
        addSubview(fengeView1)
        addSubview(commentButton)
        addSubview(fengeView2)
        addSubview(unlikeButton)
        
        // 2.布局子控件
        retweetButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(commentButton.snp_left)
            make.left.top.bottom.equalTo(self)
            
        }
        fengeView1.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(retweetButton.snp_right)
            make.width.equalTo(2)
            make.height.top.equalTo(self)
        }
        commentButton.snp_makeConstraints { (make) -> Void in
            make.top.bottom.equalTo(self)
            make.width.equalTo(retweetButton)
        }
        fengeView2.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(commentButton.snp_right)
            make.width.equalTo(2)
            make.height.top.equalTo(self)
        }
        unlikeButton.snp_makeConstraints { (make) -> Void in
            make.right.top.bottom.equalTo(self)
            make.left.equalTo(commentButton.snp_right)
            make.width.equalTo(commentButton)
        }
    }
    
    // MARK:- lazy
    /** 分割线 */
    private lazy var fengeView1: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    /** 转发按钮 */
    private lazy var retweetButton: UIButton = {
        let btn = MGButton(imageName: "timeline_icon_retweet", title: "转发", target: self, action: "retweetButtonClick")
        return btn
        }()
    /** 分割线 */
    private lazy var fengeView2: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    /** 评论按钮 */
    private lazy var commentButton: UIButton = {
        let btn = MGButton(imageName: "timeline_icon_comment", title: "评论", target: self, action: "commentButtonClick")
        return btn
        }()
    /** 赞按钮 */
    private lazy var unlikeButton: UIButton = {
        let btn = MGButton(imageName: "timeline_icon_unlike", title: "赞", target: self, action: "unlikeButtonClick")
        return btn
        }()
    
    // MARK:- 操作方法
    // MARK:- 底部视图的按钮的点击方法
    @objc private func retweetButtonClick(){
        
    }
    @objc private func commentButtonClick(){
        
    }
    @objc private func unlikeButtonClick(){
        
    }
}
