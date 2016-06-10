//
//  MGPhotoBrowserViewController.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SDWebImage

class MGPhotoBrowserViewController: UIViewController {
    // 需要显示的图片数组
    var pictures: [MGPicture]?
    // 需要显示的图片的索引
    var indexPath: NSIndexPath?
    
    // MARK:- 系统方法
    init(pictures: [MGPicture]? , indexPath: NSIndexPath?){
        self.pictures = pictures
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()

        setUpUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }

    // MARK:- 内部控制方法
    private func setUpUI(){
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        view.addSubview(originBtn)
        view.addSubview(zanBtn)
        
        // 2.布局子控件
        collectionView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view).offset(0)
        }
        closeBtn.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(view).offset(20)
            make.size.equalTo(CGSizeMake(60, 40))
        }
        saveBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-15)
            make.left.equalTo(view).offset(15)
            make.size.equalTo(CGSizeMake(60, 40))
        }
        originBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view).offset(-15)
            make.left.equalTo(saveBtn.snp_right).offset(15)
            make.size.equalTo(CGSizeMake(60, 40))
        }
        zanBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.right.equalTo(view).offset(-15)
            make.size.equalTo(CGSizeMake(60, 40))
        }
    }
    
    // MARK:- 监听按钮操作
    @objc private func closeBtnClick() {
        // 1.取得indexPath
        let indexPath = collectionView.indexPathsForVisibleItems().first
        
        // 2.取得cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! MGPhotoBrowserCell
        
        cell.activityIndicatorView.stopAnimating()
        
        // 3.dismiss控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func saveBtnClick() {
        // 1.取得indexPath
        let indexPath = collectionView.indexPathsForVisibleItems().first

        // 2.取得cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! MGPhotoBrowserCell
        
        cell.activityIndicatorView.startAnimating()
        
        // 3.取得image
        if let image = cell.photoView.image {
            // 4.将图片保存到相册中
            // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
            UIImageWriteToSavedPhotosAlbum(image, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
        }
        
        cell.activityIndicatorView.stopAnimating()
    }
    @objc private func originBtnClick() {
        
    }
    
    // MARK:- 保存图片的方法
    func image(image: UIImage, didFinishSavingWithError error:NSError?, contextInfo:AnyObject?){
        guard error == nil else{
            SVProgressHUD.showErrorWithStatus("保存图片失败")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            return
        }
        SVProgressHUD.showSuccessWithStatus("保存图片成功")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
    }
    
    // MARK:- lazy懒加载
    private lazy var closeBtn: UIButton = MGButton(title: "关闭", target: self, action: "closeBtnClick")
    private lazy var saveBtn: UIButton = MGButton(title: "保存", target: self, action: "saveBtnClick")
    private lazy var originBtn: UIButton = MGButton(title: "原图", target: self, action: "originBtnClick")
    
    private lazy var zanBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), forState: UIControlState.Normal)
        return btn
    }()
    /** 用来显示大图的collectionView */
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: MGPhotoBrowserFlowLayout())
        clv.dataSource = self
        clv.registerClass(MGPhotoBrowserCell.self, forCellWithReuseIdentifier: MGPhotoBrowserIdentifier)
        return clv
    }()
}

// MARK:- MGPhotoBrowserFlowLayout
class MGPhotoBrowserFlowLayout: UICollectionViewFlowLayout{
    override func prepareLayout() {
        // 1.设置FlowLayout的属性
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 2.设置FlowLayout的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}

// MARK:- collectionView数据源
let MGPhotoBrowserIdentifier = "MGPhotoBrowserIdentifier"
extension MGPhotoBrowserViewController: UICollectionViewDataSource,MGPhotoBrowserCellDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MGPhotoBrowserIdentifier, forIndexPath: indexPath) as! MGPhotoBrowserCell

//        let url =  pictures![indexPath.row].large_URL! as NSURL
//        guard let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(url) else {
//            return cell
//        }
//        cell.photoView.image = image
        cell.photo_URL = pictures![indexPath.item].large_URL!
        
        cell.delegate = self
        return cell
    }
    
    // MARK:- MGPhotoBrowserCellDelegate
    func photoBrowserCellDidClose(cell: MGPhotoBrowserCell) {
        closeBtnClick()
    }
}


