//
//  MGPhotoSelectViewController.swift
//  图片选择器
//
//  Created by ming on 16/4/13.
//  Copyright © 2016年 ming. All rights reserved.

// https://github.com/LYM-mg/-.git

import UIKit

class MGPhotoSelectViewController: UIViewController {
    
    var photos = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()

        setUpUI()
    }
    
    // MARK:- 内部控制方法
    private func setUpUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        
        // 2.布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionView": collectionView])
        
        view.addConstraints(cons)
    }
    
    // MARK:- lazy 懒加载
    private let flowLayout: MGPhotoFlowLayout = MGPhotoFlowLayout()
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: self.flowLayout)
        clv.dataSource = self
        clv.registerClass(MGPhotoSelectCell.self, forCellWithReuseIdentifier: MGPhotoCellIdentifier)
        return clv
    }()
}

class MGPhotoFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        let col: Int = 3
        let margin:CGFloat = 10
        let width: CGFloat = (collectionView!.frame.size.width - CGFloat(col + 1) * margin)/CGFloat(col)
        itemSize = CGSizeMake(width, width)
        
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin)
    }
}

// MARK:- UICollectionView 数据源
let MGPhotoCellIdentifier = "MGPhotoCellIdentifier"
extension MGPhotoSelectViewController: UICollectionViewDataSource,MGPhotoSelectCellDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MGPhotoCellIdentifier, forIndexPath: indexPath) as! MGPhotoSelectCell
        cell.delegate = self
        cell.backgroundColor = UIColor.redColor()
        cell.image = indexPath.item < photos.count ? photos[indexPath.item] : nil
        
        return cell
    }
    
    // MARK:- MGPhotoSelectCellDelegate 自定义代理
    func photoSelectDidIconButtonClick(cell: MGPhotoSelectCell) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            return
        }
        
        let imagePickerVc = UIImagePickerController()
        imagePickerVc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerVc.delegate = self
        // 运用常景：用来上传用户圆角图片
//        imageVC.allowsEditing = true
        
        presentViewController(imagePickerVc, animated: true, completion: nil)
    }
    
    func photoSelectDidCloseButtonClick(cell: MGPhotoSelectCell) {
        // 第一种方法：
        let indexPath = collectionView.indexPathForCell(cell)
        photos.removeAtIndex((indexPath?.item)!)
        collectionView.reloadData()
        
        // 第二种方法：给cell绑定tag
//        cell.tag = indexPath?.item
    }
}

extension MGPhotoSelectViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    // 只要手动实现了这个方法，系统就不会帮我们dismiss掉控制器
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let newImage = image.scaleImage(flowLayout.itemSize.width)
        
        photos.append(newImage)
        dismissViewControllerAnimated(true, completion: nil)
        
        collectionView.reloadData()
    }
}

