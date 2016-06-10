//
//  MGNewfeatureViewController.swift
//  MGWeibo
//
//  Created by ming on 16/3/26.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
// MARK:- MGNewfeatureViewController
class MGNewfeatureViewController: UICollectionViewController {
    let maxImageCount = 4
    let newfeatureReuseIdentifier = "newfeatureReuseIdentifier"
    let flowLayout = MGCollectionViewFlowLayout()
    init() {
        super.init(collectionViewLayout: flowLayout)
        collectionView?.registerClass(MGNewfeatureCell.self, forCellWithReuseIdentifier: newfeatureReuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- UICollViewDataSource
extension MGNewfeatureViewController{
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxImageCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(newfeatureReuseIdentifier, forIndexPath: indexPath) as! MGNewfeatureCell
        cell.startButton.hidden = indexPath.item != (maxImageCount - 1)
        cell.index = indexPath.item
        
        return cell
    }
    
    /**
    *   完全显示一个Cell之后调用
    *   - parameter indexPath: 是上一页的indexPath
    */
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let path = NSIndexPath(forItem: indexPath.item + 1, inSection: 0)
        if let cell = collectionView.cellForItemAtIndexPath(path) as? MGNewfeatureCell{
            
            cell.startButton.transform = CGAffineTransformMakeScale(0.3, 0.3)
            cell.startButton.userInteractionEnabled = false
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    cell.startButton.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    cell.startButton.userInteractionEnabled = true
            })
        }
    }
}

// MARK:- MGCollectionViewCell
class MGNewfeatureCell: UICollectionViewCell{
    // MARK：- 懒加载
    private lazy var pageView = UIImageView()
    
    lazy var startButton: UIButton = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "startButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
    
    // MARK：- 事件监听
    @objc private func startButtonClick(){
        MGNotificationCenter.postNotificationName(MGSwitchRootViewControllerNotification, object: nil, userInfo: nil)
    }
    
    var index: Int? {
        didSet{
            pageView.image = UIImage(named: "new_feature_\(index! + 1)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 内部控制方法
    private func setUpUI(){
        // 1.添加子控件
        contentView.addSubview(pageView)
        contentView.insertSubview(startButton, aboveSubview: pageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 2.设置子控件的尺寸
        pageView.frame = contentView.bounds
        
        startButton.frame.size.width = 150
        startButton.frame.size.height = 35
        startButton.center.x = contentView.center.x
        startButton.center.y = contentView.frame.size.height * 0.6
        print(startButton.frame)
    }
}


// MARK:- MGCollectionViewFlowLayout
class MGCollectionViewFlowLayout:UICollectionViewFlowLayout{
    override func prepareLayout() {
        // 1.设置FlowLayout的属性
        itemSize = UIScreen.mainScreen().bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        // 2.设置FlowLayout的属性
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
    }
}
