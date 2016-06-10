//
//  Common.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

// 主窗口
let MGKeyWindow = UIApplication.sharedApplication().keyWindow

// 通知中心
let MGNotificationCenter = NSNotificationCenter.defaultCenter()

// MARK:- popView的弹出和消失的通知
let MGPopoverPresentedNotification = "MGPopoverPresentedNotification"
let MGPopoverDismissNotification = "MGPopoverDismissNotification"

// MARK:- 切换窗口根控制器的通知
let MGSwitchRootViewControllerNotification = "MGSwitchRootViewControllerNotification"

// MARK:- 监听图片浏览器通知
let MGPictViewShowPhotoBrowserNotification = "MGPictViewShowPhotoBrowserNotification"

// MARK:- 请求授权需要的参数
let App_Key = "4270356641"
let App_Secret = "4df5c8fef3fae05b2451421dce4721b8"
let redirect_uri = "http://www.520it.com"

// MARK:- 全局参数
let MGSCreenWidth = UIScreen.mainScreen().bounds.size.width
let MGSCreenHeight = UIScreen.mainScreen().bounds.size.height
// 全局间距
let MGMargin = 10
