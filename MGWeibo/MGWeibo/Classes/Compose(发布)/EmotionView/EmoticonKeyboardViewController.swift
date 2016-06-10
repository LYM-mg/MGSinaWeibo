//
//  EmoticonKeyboardViewController.swift
//  0-表情键盘
//
//  Created by ming on 16/4/11.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class EmoticonKeyboardViewController: UIViewController {
    var insertEmoticon: (emoticon: MGEmoticon) -> ()
    init(callBack: (emoticon: MGEmoticon) -> ()){
        insertEmoticon = callBack
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        // 1.初始化UI
        setupUI()
    }
    
    // MARK: - 内部控制方法
    private func setupUI(){
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolbar)
        
        // 2.布局子控件
        // 2.布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let dict = ["collectionView": collectionView, "toolbar": toolbar]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionView]-[toolbar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)
        
        view.addConstraints(cons)
    }
    
    // MARK:- 1.itemBtnClick
    func itemBtnClick(item: UIBarButtonItem){
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    // MARK: - 懒加载
    private lazy var collectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: MGEmoticonFlowLayout())
        clv.registerClass(MGEmoticonCell.self, forCellWithReuseIdentifier: MGEmoticonCellReuseIdentifier)
        clv.dataSource = self
        clv.delegate = self
        clv.backgroundColor = UIColor.greenColor()
        return clv
    }()
    /** 工具栏 */
    private lazy var toolbar: UIToolbar = {
        let tb = UIToolbar()
        let array = ["最近", "默认", "Emoji","浪小花"]
        var items = [UIBarButtonItem]()
        var index: Int = 0
        
        for title in array {
             let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("itemBtnClick:"))
             item.tag = index++
             items.append(item)
             items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        tb.backgroundColor = UIColor.blackColor()
        tb.tintColor = UIColor.blackColor()
        tb.frame.size.height = 44
        tb.items = items
        return tb
    }()
    
    /** 包含所有组的表情 */
    private lazy var packages: [MGEmoticonPackage] = MGEmoticonPackage.loadPackages()
}

// MARK:- MGEmoticonFlowLayout
class MGEmoticonFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        let width = UIScreen.mainScreen().bounds.size.width / 7
        itemSize = CGSize(width: width, height: width)
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 注意：如果乘以0.5iPhone4s和iPhone4上会有问题
        let margin = (collectionView!.frame.height - 3 * width) * 0.49
        collectionView?.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0)
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}

// MARK:- UICollectionViewDataSource,UICollectionViewDelegate
extension EmoticonKeyboardViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    // MARK:- UICollectionViewDataSource
    // 返回多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    // 返回每一组有多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons!.count ?? 0
    }
    // 每一组每一行cell显示什么
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! MGEmoticonCell
        
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        cell.emoticon = emoticon
        
        return cell
    }
    
    // MARK:- UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        insertEmoticon(emoticon: emoticon)
        
        /// 将使用过的表情添加到最近界面
        if !emoticon.isRemoveButton {
             packages.first!.appendRecentEmoticons(emoticon)
            collectionView.reloadSections(NSIndexSet(index: 0))
        }
    }
}

let MGEmoticonCellReuseIdentifier = "MGEmoticonCellReuseIdentifier"

class MGEmoticonCell: UICollectionViewCell {
    var emoticon: MGEmoticon? {
        didSet {
            emoticonButton.setImage(nil, forState: UIControlState.Normal)
            if let path = emoticon?.imagePath {
                emoticonButton.setImage(UIImage(contentsOfFile: path), forState: UIControlState.Normal)
            }
            
            emoticonButton.setTitle(emoticon?.emoji ?? "", forState: UIControlState.Normal)
            
            if let e = emoticon where e.isRemoveButton {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                 emoticonButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 初始化UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 内部控制方法
    private func setupUI() {
        // 1.添加子控件
        contentView.addSubview(emoticonButton)
        
        // 2.布局子控件
//        emoticonButton.frame = contentView.frame
        emoticonButton.frame = CGRectInset(bounds, 3, 3)
    }
    
    // MARK:- 懒加载
    private lazy var emoticonButton: UIButton = {
         let btn = UIButton()
         btn.backgroundColor = UIColor.whiteColor()
         btn.titleLabel?.font = UIFont.systemFontOfSize(32)
         btn.userInteractionEnabled = false
         return btn
    }()
}
