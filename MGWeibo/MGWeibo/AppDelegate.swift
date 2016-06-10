//
//  AppDelegate.swift
//  MGWeibo
//
//  Created by ming on 16/1/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // 0.setUpNavAppearance
        setUpNavAppearance()
        
        // 1.创建Window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // 2.设置窗口根控制器
//        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        window?.rootViewController = defaultViewController()
        
        // 3.显示窗口
        window?.makeKeyAndVisible()
        
        // 4.监听通知
        MGNotificationCenter.addObserver(self, selector: "switchRootViewController:", name: MGSwitchRootViewControllerNotification, object: nil)
        
        return true
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // 清除5天前的微博缓存
        MGStatusListModel.clearStatus()
    }
    
    // MARK:-通知切换窗口根控制器方法
    @objc func switchRootViewController(noti: NSNotification) {
        // 1.vc默认是主界面
        var vc: UIViewController? = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        
        // 2.如果是欢迎控制器
        if noti.userInfo != nil {
            vc = MGWelcomeViewController()
        }
        // 3.转场动画
        let transition = CATransition()
        transition.type = "rippleEffect"
        transition.duration = 1.0
        MGKeyWindow?.rootViewController = vc
        MGKeyWindow?.layer.addAnimation(transition, forKey: nil)
    }
    deinit{
        MGNotificationCenter.removeObserver(self)
    }
    
    // MARK:- 修改全局的tintColor
    func setUpNavAppearance() {
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    }
    
    // MARK:- 返回默认的控制器
    private func defaultViewController() -> UIViewController{
        if MGUserAccountViewModel.shareInstance.isUserLogin() {
            return isNewVersion() ? MGNewfeatureViewController() : MGWelcomeViewController()
        }
        return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
    }
    
    // MARK:- 判断版本号
    func isNewVersion() -> Bool{
        // 取得沙盒那边的版本号
        guard let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String else{
            MGLog("没有获取到当前版本号")
            return false
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let nextVersion = defaults.valueForKeyPath("CFBundleShortVersionString") == nil ? "0.0" : defaults.valueForKeyPath("CFBundleShortVersionString") as! String
        print("currentVersion=\(currentVersion) nextVersion=\(nextVersion)")
        if currentVersion.compare(nextVersion) == NSComparisonResult.OrderedDescending {
            defaults.setValue(currentVersion, forKeyPath: "CFBundleShortVersionString")
            return true
        }

        return false
    }
}

// 全局打印：传递的是默认参数 ，判断是否是Debug模式
func MGLog<Anytype>(message:Anytype, funcName : String = __FUNCTION__, lineNum :Int = __LINE__){
    #if ABC
        print("\(funcName)" + "(\(lineNum))" + "\(message)")
    #endif
}

// 全局打印：传递的是默认参数 ，判断是否是Debug模式
//func MGLog<Anytype>(message:Anytype, filePath : String = __FILE__, funcName : String = __FUNCTION__, lineNum :Int = __LINE__){
//    #if ABC
//        let fileName = (filePath as NSString).lastPathComponent
//        print(fileName + "[\(funcName)]" + "(\(lineNum))" + "message")
//    #endif
//}

