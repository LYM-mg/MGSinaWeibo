//
//  MGHomePictureView.swift
//  MGWeibo
//
//  Created by ming on 16/4/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SDWebImage

class MGHomePictureView: UICollectionView {
    // MARK:- MGStatusViewModel模型
    var viewModel: MGStatusViewModel?{
        didSet{
            let size = caclatePicture(viewModel!)
            self.snp_updateConstraints { (make) -> Void in
                make.size.equalTo(size)
            }
            // 刷新数据
            reloadData()
        }
    }
    
    // MARK:- 系统方法
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    init(){
        super.init(frame: CGRectZero, collectionViewLayout: layout)
        dataSource = self
        delegate = self
        backgroundColor = UIColor.lightGrayColor()
        registerClass(MGPictureCell.self, forCellWithReuseIdentifier: MGPictureCellIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- 计算配图尺寸
extension MGHomePictureView {
    /**
    0.没有图片，返回zero
    1.单张图片，返回图片实际大小
    2.多张图片，图片大小固定
    2.1四张图片，会按照田字格实现
    2.2其他图片，按照九宫格显示
    */
    /**
    计算配图尺寸
    -paramater status: 数据模型
    */
    private func caclatePicture(viewModel: MGStatusViewModel) -> CGSize {
        // 1.安全校验
        guard let pictures = viewModel.pictures else {
            return CGSizeZero
        }
        
        // 2.取出配图个数
        let count = pictures.count
        
        // 3.判断配图个数
        // 3.1没有配图
        if count == 0 {
            return CGSizeZero
        }
        // 3.2单张配图
        if count == 1 {
            let url = pictures.first!.thumbnail_pic!
            guard let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url) else {
                return CGSizeZero
            }
            let width: CGFloat = image.size.width * 2.5
            let height: CGFloat = image.size.height * 2.5
            layout.itemSize = CGSize(width: width, height: height)
            return layout.itemSize
        }
        
        let itemWidth = 90
        let itemHeight = itemWidth
        let margin = MGMargin
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // 3.3四张配图
        if count == 4 {
            let col = 2
            let row = col
            
            let width = col * itemWidth + (col - 1) * margin
            let height = row * itemHeight + (row - 1) * margin
            return CGSize(width: width, height: height)
        }
        // 3.4多张配图
        let col = 3
        let row = (count - 1)/col + 1
        // 宽度 = 列数 * 宽度 + (列数 - 1) * 宽度
        let width = col * itemWidth + (col - 1) * margin
        // 高度 = 行数 * 高度 + (行数 - 1) * 高度
        let height = row * itemHeight + (row - 1) * margin
        return CGSize(width: width, height: height)
    }
}

// MARK:- UICollectionViewDataSource 数据源
let MGPictureCellIdentifier = "MGPictureCellIdentifier"
extension MGHomePictureView: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel!.pictures?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MGPictureCellIdentifier, forIndexPath: indexPath) as! MGPictureCell
        cell.imageURL = viewModel!.pictures![indexPath.item].thumbnail_URL
        return cell
    }
}

// MARK:- UICollectionViewDataSource 代理
extension MGHomePictureView: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MGPictureCell
        
        let url = viewModel?.pictures![indexPath.item].large_URL
        
        // 1.SDWebImageManager下载图片
        SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: { (current, total) -> Void in
                cell.peituView.progress = CGFloat(current) / CGFloat(total)
            }) { (_, error, _, _, _) -> Void in
                // 2.发布通知
                MGNotificationCenter.postNotificationName(MGPictViewShowPhotoBrowserNotification, object: nil, userInfo: ["pictures" : self.viewModel!.pictures!,"indexPath": indexPath])
        }
    }
}

// MARK:- MGPictureCell
class MGPictureCell: UICollectionViewCell {
    var imageURL: NSURL? {
        didSet{
            gifView.hidden = true
            peituView.sd_setImageWithURL(imageURL)
            
            if let gifURL = imageURL {
                gifView.hidden = (gifURL.absoluteString.lowercaseString as NSString).pathExtension != "gif"
            }
        }
    }
    
    /** 配图 */
    lazy var peituView: MGProgressImageView = {
        let iv = MGProgressImageView()
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    /** gif图标 */
    private lazy var gifView: UIImageView = {
        let giv = UIImageView(image: UIImage(named: "gif"))
        return giv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1.添加子控件
        contentView.addSubview(peituView)
        contentView.addSubview(gifView)
        
        // 2.布局子控件
        peituView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        gifView.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(contentView).offset(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
