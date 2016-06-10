//
//  MGPhotoSelectCell.swift
//  图片选择器
//
//  Created by ming on 16/4/13.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

// MARK:- MGPhotoSelectCell 图片cell
protocol MGPhotoSelectCellDelegate: NSObjectProtocol
{
    func photoSelectDidIconButtonClick(cell: MGPhotoSelectCell)
    func photoSelectDidCloseButtonClick(cell: MGPhotoSelectCell)
}

class MGPhotoSelectCell: UICollectionViewCell {
    
    var delegate: MGPhotoSelectCellDelegate?
    var image: UIImage?{
        didSet{
            if image == nil {
                iconButton.setImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                iconButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
                closeButton.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
            }else {
                iconButton.setImage(image, forState: .Normal)
            }
            
            iconButton.userInteractionEnabled = (image == nil)
            closeButton.hidden = (image == nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 内部控制方法
    private func setUpUI() {
        // 1.添加子控件
        contentView.addSubview(iconButton)
        contentView.addSubview(closeButton)
        
        // 2.布局子控件
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[iconButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconButton": iconButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[iconButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconButton": iconButton])
        
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:[closeButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton": closeButton])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[closeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton": closeButton])
        contentView.addConstraints(cons)
    }
    
    // MARK:- 事件操作
    @objc private func selectPicture() {
        delegate?.photoSelectDidIconButtonClick(self)
    }
    
    @objc private func closeButtonClick() {
        delegate?.photoSelectDidCloseButtonClick(self)
    }
    
    // MARK:- lazy 懒加载
    private lazy var iconButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_pic_add"), forState: .Normal)
        btn.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
        btn.addTarget(self, action: Selector("selectPicture"), forControlEvents: .TouchUpInside)
        return btn
        }()
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        btn.addTarget(self, action: Selector("closeButtonClick"), forControlEvents: .TouchUpInside)
        return btn
        }()
}

