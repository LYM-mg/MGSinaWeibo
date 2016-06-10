//  MGHomeViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.

//  MGLog(MGUserAccountModel.filePath)

import UIKit
import SVProgressHUD
import SDWebImage

class MGHomeViewController: MGBaseViewController {
    // MARK:- 控制器的生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 0.判断是否登录
        if !isLogin {
            // 添加转盘动画
            startAnimationRotation()
            return;
        }
        /// 1.初始化导航控制器
        setUpNavgationItems()
        
        /// 2.监听popView的弹出和消失的通知
        setUpNotifications()
        
        /// 3.初始化TableView
        setUpTableView()
    }
    
    // MARK:- 初始化TableView
    private func setUpTableView(){
        /// 3.注册cell
        tableView.registerClass(MGHomeTableViewForwardCell.self, forCellReuseIdentifier: MGHomeTableViewCellIdentifier.ForwardCellIdentifier.rawValue)
        tableView.registerClass(MGHomeTableViewNormalCell.self, forCellReuseIdentifier: MGHomeTableViewCellIdentifier.NormalCellIdentifier.rawValue)
        
        /// 4.添加下拉刷新
        /*
        1.refreshControl有默认的尺寸
        2.调用refreshControl的beginRefreshing不会触发监听方法
        3.调用refreshControl的endRefreshing回关闭刷新界面
        4.refreshControl只要拉倒一定程度就会触发监听方法
        注意点: beginRefreshing不会触发监听方法
        refreshControl?.beginRefreshing()
        */
        refreshControl = MGRefreshControl()
        refreshControl?.addTarget(self, action: ("loadData"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl?.beginRefreshing()
        
        /// 5.加载微博数据
        loadData()

    }
    
    // MARK:- 加载微博数据/加载最新微博数据
    @objc private func loadData() {
        // 2.发送网络请求数据
        statusListModel.loadData(pullUpFlag) { (error, models) -> () in
            guard error == nil else
            {
                self.refreshControl?.endRefreshing()
                SVProgressHUD.showErrorWithStatus(String(error))
                SVProgressHUD.setDefaultMaskType(.Black)
                return
            }
            
            self.showRefreshTipLabel(models!.count)
            
            // 0.恢下拉可以刷新状态复
            self.pullUpFlag = false

            // 1.关闭下拉刷新
            self.refreshControl?.endRefreshing()

            // 2.刷新表格
            self.tableView.reloadData()
        }
    }
    
    // MARK:- 刷新微博提醒数字
    func showRefreshTipLabel(count: Int) {
        
        self.refreshTipLabel.hidden = false
        refreshTipLabel.text = "没有更多微博数据"
        
        if count > 0 {
            refreshTipLabel.text = "有\(count)条新的微博"
        }
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.refreshTipLabel.transform = CGAffineTransformMakeTranslation(0,self.refreshTipLabel.frame.height)
            }) { (_) -> Void in
                UIView.animateWithDuration(0.5, delay: 1.5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    self.refreshTipLabel.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.refreshTipLabel.hidden = true
                })
        }
    }
    
    // MARK:- 监听popView的弹出和消失的通知
    func setUpNotifications(){
        // 监听popView的弹出的通知，箭头向下
       MGNotificationCenter.addObserverForName(MGPopoverPresentedNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti) -> Void in
            self.titleButton.selected = true
        }
        // 监听popView的消失的通知,箭头向上
        MGNotificationCenter.addObserverForName(MGPopoverDismissNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti) -> Void in
            self.titleButton.selected = false
        }
        // 注册通知监听图片浏览器
        MGNotificationCenter.addObserverForName(MGPictViewShowPhotoBrowserNotification, object: nil, queue: nil) { (noti) -> Void in
            guard let userInfo = noti.userInfo else {
                return
            }
            guard let pictures = userInfo["pictures"] as?[MGPicture] else {
                MGLog("没有要显示的配图")
                return
            }
            guard let indexPath = userInfo["indexPath"] as? NSIndexPath else {
                MGLog("没有要显示的索引")
                return
            }
            
            let photoBrowser = MGPhotoBrowserViewController(pictures: pictures, indexPath: indexPath)
//            photoBrowser.pictures = noti.userInfo["pictures"] as! [MGPicture]
//            photoBrowser.indexPath = noti.userInfo["indexPath"] as! NSIndexPath
            self.presentViewController(photoBrowser, animated: true, completion: nil)
        }
    }
    deinit{
        MGNotificationCenter.removeObserver(self)
    }
    
    // MARK:- 自定义函数
    /// 初始化导航控制器
    private func setUpNavgationItems() {
        // 1.初始化左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: MGButton(imageName: "navigationbar_friendattention", target: self, action: "friendBtnClick"))
        
        // 2.初始化左侧的Item
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView:MGButton(imageName: "navigationbar_pop", target: self, action: "qrCodeBtnClick"))
        
        // 3.初始化标题的按钮
        navigationItem.titleView = titleButton
    }
    
    // MARK:- 事件监听函数
    /// 联系人按钮的点击
    @objc private func friendBtnClick() {
        
    }
    
    /// 二维码按钮的点击
    @objc private func qrCodeBtnClick() {
        // 1.创建控制器
        let qrCodestroyboard = UIStoryboard(name: "QRCode", bundle: nil)
        let qrCodeVC = qrCodestroyboard.instantiateInitialViewController()!
        
        // 2.弹出控制器
        presentViewController(qrCodeVC, animated: true, completion: nil)
    }
    
    /// 中间标题按钮的点击
    @objc private func titleButtonClick(titleBtn:TitleButton) {
        // 1.改变按钮的状态
        titleBtn.selected = !titleBtn.selected;
        
        // 2.设置分组控制器
        let popViewVc = MGPopViewController()
        
        // 3.设置popViewVc属性
        // 3.1popViewVc弹出样式(自定义)
        popViewVc.modalPresentationStyle = .Custom
        
        // 3.2设置转场代理(通过转场代理自定义转场)
        popViewVc.transitioningDelegate = popoverAnimator;
        
        // 4.弹出控制器
        presentViewController(popViewVc, animated: true, completion: nil)
    }
    
    // MARK:- 懒加载
    /// 创建处理微博数据
    var statusListModel: MGStatusListModel = MGStatusListModel()
    
    /// 创建titleButton
    private lazy var titleButton:TitleButton = {
        let titleButton = TitleButton()
        titleButton.addTarget(self, action: "titleButtonClick:", forControlEvents: .TouchUpInside)
        return titleButton
        }()
    
    /// 创建popoverAnimator
    private lazy var popoverAnimator : MGPopoverAnimator = {
        let popoverAnimator = MGPopoverAnimator()
        let width: CGFloat = 150
        let height: CGFloat = 200
        let x: CGFloat = (UIScreen.mainScreen().bounds.width - width)/2
        let y: CGFloat = 56;
        popoverAnimator.presentedFrame = CGRectMake(x, y, width, height)
        return popoverAnimator
        }()
    
    /// 缓存行高（用微博ID作为key，对应的行高作为value）
    private lazy var rowHeightCache = [String: CGFloat]()
    
    /// 下拉刷新提醒Label数字
    private lazy var refreshTipLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = NSTextAlignment.Center
        lb.frame = CGRectMake(0, 0, MGSCreenWidth, 44)
        lb.hidden = true
        lb.font = UIFont.boldSystemFontOfSize(16)
        lb.textColor = UIColor.purpleColor()
        lb.backgroundColor = UIColor(red: 0.5, green: 0, blue: 1, alpha: 0.7)
        self.navigationController?.navigationBar.insertSubview(lb, atIndex: 0)
        return lb
    }()
    
    /// 定义标记记录是否正在加载更多数据
    var pullUpFlag: Bool = false
}

// MARK:- 数据源方法
extension MGHomeViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // "??"的意思是如果为nil 就执行 “??”后面的内容
        return statusListModel.statusList?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.取出模型
        let viewModel = statusListModel.statusList![indexPath.row]
        
        // 2.判断不同的cell
        let cell = tableView.dequeueReusableCellWithIdentifier(MGHomeTableViewCellIdentifier.cellWithViewModel(viewModel), forIndexPath: indexPath) as! MGHomeTableViewCell
        
        // 3.给cell赋值
        cell.viewModel = viewModel
        
        if indexPath.row == (statusListModel.statusList?.count)! - 1 && !pullUpFlag {
            pullUpFlag = true
            loadData()
        }
        
        return cell
    }
}

// MARK:- 代理方法
extension MGHomeViewController{
    // 返回行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        // 1.取出模型
        let viewModel = statusListModel.statusList![indexPath.row]
        
        // 2.从缓存中获取行高
        guard let height = rowHeightCache[viewModel.status!.idstr!] else{ // 没有缓存
            // 2.1判断不同的cell
            let cell = tableView.dequeueReusableCellWithIdentifier(MGHomeTableViewCellIdentifier.cellWithViewModel(viewModel)) as! MGHomeTableViewCell

            let tempHeight = cell.rowHeight(viewModel)
            // 2.2缓存到字典
            rowHeightCache[viewModel.status!.idstr!] = tempHeight

            return tempHeight
        }
        
        // 有缓存
        return height
    }
    
    // MARK:- UIScrollView代理方法
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}

