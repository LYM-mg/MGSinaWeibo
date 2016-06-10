//
//  MGPhotoBrowserCell.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

/// 协议
@objc
protocol MGPhotoBrowserCellDelegate: NSObjectProtocol
{
    optional func photoBrowserCellDidClose(cell: MGPhotoBrowserCell)
}
// MARK:- MGPhotoBrowserCell
class MGPhotoBrowserCell: UICollectionViewCell {
    weak var delegate: MGPhotoBrowserCellDelegate?
    
    // 点击图片退出浏览器
    @objc private func close() {
        delegate?.photoBrowserCellDidClose!(self)
    }
    
    var photo_URL: NSURL?
        {
        didSet{
            // 0.显示菊花
            activityIndicatorView.startAnimating()
            
            // 1.防止循环利用,清空
            resetScrollView()
            
            // 2.设置图片
            photoView.sd_setImageWithURL(photo_URL) { (image, error, _, _) -> Void in
                
                self.activityIndicatorView.stopAnimating()
                
                // 3.设置图片的位置和尺寸
                self.disPlayPosition()
            }
        }
    }
    // MARK:- 图片有关方法
    /**
    *   计算图片的尺寸
    */
    private func disPlaySize() -> CGSize {
        guard let image = photoView.image else {
            MGLog("image = nil")
            return CGSizeZero
        }
        let scale = MGSCreenWidth/image.size.width
        let cellHeight = image.size.height * scale
        return CGSizeMake(MGSCreenWidth, cellHeight)
    }
    /**
    *   计算图片的位置
    */
    private func disPlayPosition() {
        let size = disPlaySize()
        photoView.frame = CGRect(origin: CGPointZero, size: size)
        // 判断长短图
        if size.height < MGSCreenHeight {
            let offset = (MGSCreenHeight - size.height) * 0.5
            scrollView.contentInset = UIEdgeInsetsMake(offset, 0, 0, 0)
        }else {
            scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(photoView.frame))
        }
    }
    
    // 防止循环利用
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
        // 注意：如果重用之前已经放到最大，那么就没法继续放大
        photoView.transform = CGAffineTransformIdentity
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        // 1.添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(photoView)
        contentView.addSubview(activityIndicatorView)
        
        // 2.布局子控件
        scrollView.frame = contentView.bounds
        scrollView.backgroundColor = UIColor.purpleColor()
        activityIndicatorView.center = contentView.center
    }
    
    /** 用来缩放图片等待的photoView */
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.minimumZoomScale = 0.5
        sv.maximumZoomScale = 2.0
        sv.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: "close")
        sv.addGestureRecognizer(tap)
        return sv
        }()
    /** 用来显示图片等待的photoView */
    lazy var photoView: UIImageView = {
        let iv = UIImageView()
//        iv.userInteractionEnabled = true
        return iv
        }()
    /** 用来加载大图片等待的菊花 */
    lazy var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}

// MARK:- UIScrollViewDelegate
extension MGPhotoBrowserCell: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        var offsetY = (scrollView.frame.height - view!.frame.height) * 0.5
        var offsetX = (scrollView.frame.width - view!.frame.width) * 0.5
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)
    }
}

