//
//  MGComposeViewController.swift
//  MGWeibo
//
//  Created by ming on 16/4/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import SVProgressHUD

class MGComposeViewController: UIViewController {

    // MARK:- 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        
        // 1.添加导航栏的按钮
        setUpNavgationItems()
    
        // 2.设置inputTextView/设置工具toolBar
        setUpTextView()
        
        // 3.添加表情键盘
        addChildViewController(keyboardVC)
        
        // 4.监听键盘尺寸的改变
        MGNotificationCenter.addObserver(self, selector: Selector("keyboardFrameChange:"), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        // 5.添加图片选择器
        addChildViewController(photoSelectVC)
        view.insertSubview(photoSelectVC.view, belowSubview: toolBar)
        photoSelectVC.view.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if photoSelectVC.view.frame.height <= 0 {            
            inputTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        inputTextView.resignFirstResponder()
    }
    
    // MARK:- 内部控制函数
    // 设置inputTextView/设置工具toolBar
    private func setUpTextView() {
        // 1.添加子控件
        view.addSubview(inputTextView)
        inputTextView.addSubview(inputTextLabel)
        view.addSubview(toolBar)
        view.addSubview(maxTipLabel)
        
        // 2.布局子控件
        inputTextView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        inputTextLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(inputTextView).offset(10)
            make.left.equalTo(inputTextView).offset(5)
        }
        
        toolBar.snp_makeConstraints { (make) -> Void in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        maxTipLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(toolBar.snp_top).offset(-20)
        }
    }

    // MARK:- 自定义函数
    /// 初始化导航控制器
    private func setUpNavgationItems() {
        // 1.初始化左/右侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Done, target: self, action: "cancel")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: "sendStatus")
        navigationItem.rightBarButtonItem?.enabled = false
        // 初始化标题的按钮
        navigationItem.titleView = titleView
        // 添加子控件
        titleView.addSubview(titleLabel)
        titleView.addSubview(nameLabel)
        titleView.frame = CGRectMake(0, 0, 100, 44)
        

        // 2.布局子控件
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(titleView)
        }
        titleLabel.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(titleView)
            make.top.equalTo(nameLabel.snp_bottom)
        }
    }
    
    /// 发布键盘尺寸变化的通知
    @objc private func keyboardFrameChange(noti: NSNotification) {
        /*
        userInfo = {
             UIKeyboardAnimationCurveUserInfoKey = 7;
             UIKeyboardAnimationDurationUserInfoKey = "0.4";
             UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 365}, {375, 302}}";
        }
        */
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        let offsetY = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue.origin.y - MGSCreenHeight
        toolBar.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(offsetY)
        }
        
        let CurveValue = noti.userInfo![UIKeyboardAnimationCurveUserInfoKey]! as! Int
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
               UIView.setAnimationCurve(UIViewAnimationCurve.init(rawValue: CurveValue)!)
               self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK:- NavgationItem的监听方法
    /** 取消 */
    @objc private func cancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    /** 发布微博 */
    @objc private func sendStatus(){
        // 1.获取输入的内容
        let text = inputTextView.emoticonString()
        
        let image = photoSelectVC.photos.first
        
        // 2.发送微博
        MGNetworkTools.shareInstance.postStatus(text, image: image, finished: { (objc, error) -> () in
            guard error == nil else {
                SVProgressHUD.showErrorWithStatus("\(error)")
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
                return
            }

            SVProgressHUD.showSuccessWithStatus("微博发送成功")
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        })
        
        // 3.回到微博首页界面
        cancel()
    }
    // MARK:- 附加键盘的监听方法
    /** 选择图片 */
    @objc private func selectPicture(){
        inputTextView.resignFirstResponder()
        print( photoSelectVC.view.frame.height)

        photoSelectVC.view.snp_updateConstraints { (make) -> Void in
            make.height.equalTo(view.bounds.size.height * 0.6)
        }
    }
    /** 选择表情 */
    @objc private func inputEmoticon(){
        // 1.退出键盘
        inputTextView.resignFirstResponder()
        
        // 2.切换键盘
        inputTextView.inputView = inputTextView.inputView != nil ? nil : keyboardVC.view
        
        // 3.叫出键盘
        inputTextView.becomeFirstResponder()
    }

    // MARK:- 懒加载
    private lazy var titleView: UIView = UIView()
    
    /** titleLabel */
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "发微博"
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    /** nameLabel */
    private lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = MGUserAccountViewModel.shareInstance.userAccountModel?.screen_name
        lb.textColor = UIColor.lightGrayColor()
        lb.textAlignment = NSTextAlignment.Center
        return lb
    }()
    /** 输入inputView */
    private lazy var inputTextView: UITextView = {
        let iw = UITextView()
        iw.font = UIFont.systemFontOfSize(17)
        iw.alwaysBounceVertical = true
        iw.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        iw.delegate = self
        return iw
    }()
    /** 占位Label */
    private lazy var inputTextLabel: UILabel = {
        let lb = UILabel()
        lb.text = "分享新鲜事"
        lb.textColor = UIColor.orangeColor()
        return lb
    }()
    /** 提醒maxTipLabel */
    private lazy var maxTipLabel: UILabel = UILabel()
    var maxTextLength: Int = 100
    /** 工具条toolBar */
    private lazy var toolBar: UIToolbar = {
        let tb = UIToolbar()
        
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "selectPicture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        var items = [UIBarButtonItem]()
        for dict in itemSettings
        {
            var item: UIBarButtonItem? = nil
            if let selName = dict["action"]
            {
                item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: Selector(selName))
            }else
            {
                item = UIBarButtonItem(imageName: dict["imageName"]!, target: self, action: nil)
            }
            
            items.append(item!)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        tb.frame.size.height = 44
        tb.items = items
        return tb
    }()
    /** 表情keyboardVC */
    private lazy var keyboardVC: EmoticonKeyboardViewController = {
       let kb = EmoticonKeyboardViewController(callBack: { (emoticon) -> () in
            self.inputTextView.insertEmoticon(emoticon)
       })
        return kb
    }()
    /** 图片选择器VC */
    private lazy var photoSelectVC: MGPhotoSelectViewController = {
        let vc = MGPhotoSelectViewController()
        return vc
    }()
}


// MARk:- UITextViewDelegate
extension MGComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        
        // 提醒数字
        let res = maxTextLength - textView.text.characters.count
        if res < 0 {
            maxTipLabel.text = "你已经超出\(-res)个字"
        }else if res < 10{
            maxTipLabel.text = "你还可以输入\(res)个字"
        } else {
            maxTipLabel.text = res == maxTextLength ? "" : "\(res)"
        }
        maxTipLabel.textColor = res > 10 ? UIColor.blackColor() : UIColor.redColor()
        
        inputTextLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = (res >= 0 && textView.hasText()) || (photoSelectVC.photos.count > 0)
    }
}


