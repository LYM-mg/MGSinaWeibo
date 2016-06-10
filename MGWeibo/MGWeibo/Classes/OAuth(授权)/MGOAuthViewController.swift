//
//  MGOAuthViewController.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
// App Key：4270356641
// App Secret：4df5c8fef3fae05b2451421dce4721b8
// 授权回调页：http://www.520it.com
//  https://api.weibo.com/oauth2/authorize
//  client_id	true	string	申请应用时分配的AppKey。
//  redirect_uri	true	string	授权回调地址，站外应用需与设置的回调地址一致，站内应用需填写canvas page的地址。
//  https://api.weibo.com/oauth2/authorize?client_id=4270356641&redirect_uri=http://www.520it.com

import UIKit
import SVProgressHUD

class MGOAuthViewController: UIViewController {
    
    override func loadView() {
        view = webView
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let wv = UIWebView()
        wv.delegate = self
        return wv
        }()
    
    // MARK:- 系统的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.请求授权
        loadRequest()
        
        // 2.设置导航栏
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Done, target: self, action: "dismissClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Done, target: self, action: "fillClick")
    }
    
    // MARK:- 请求授权
    func loadRequest(){
        // 获取字符串
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&redirect_uri=\(redirect_uri)"
        guard let url = NSURL(string: urlStr) else {
            MGLog("url有错")
            return
        }
        
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    
    // MARK:- 事件监听函数
    @objc private func dismissClick(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillClick(){
        let jsCode = "document.getElementById('userId').value='13750525922';document.getElementById('passwd').value='yi3452681';"
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK: - UIWebViewDelegate
extension MGOAuthViewController : UIWebViewDelegate {
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showErrorWithStatus("正在加载ing...")
        SVProgressHUD.setDefaultMaskType(.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        dismissClick()
    }
    
    /**
    webView的该代理方法用于控制是否允许发起请求
    */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        /**
        授权成功：http://www.520it.com/?code=b1bb292c0c6b6c141f3d87a5b0367baf
        授权失败：http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
        其他界面：https://api.weibo.com/oauth2/authorize?
        */
        
        // 1.判断是否是授权回调页面
        guard  let urlStr = request.URL?.absoluteString where urlStr.hasPrefix(redirect_uri) else
        {
            return true
        }
        
        // 2.判断是否授权成功
        guard !urlStr.containsString("?error_url=") else {
            SVProgressHUD.showErrorWithStatus("授权失败")
            SVProgressHUD.setDefaultMaskType(.Black)
            return false
        }
        
        // 3.授权成功，截取code后面的内容
        if let str = request.URL?.query {
//            let code1 = str.substringFromIndex("code=".characters.count)
            // 3.1截取Code=后面的字符串
            let code = str.substringFromIndex("code=".endIndex)
                          
            // 3.2换取AccessToken
            MGUserAccountViewModel.shareInstance.loadAccessTocken(code, finished: { (error) -> () in
                guard error == nil else {
                    SVProgressHUD.showErrorWithStatus("获取授权失败\(error)")
                    SVProgressHUD.setDefaultMaskType(.Black)
                    return
                }
                
                SVProgressHUD.showSuccessWithStatus("获取授权成功")
                SVProgressHUD.setDefaultMaskType(.Black)
            
                // 3.3跳转到欢迎界面
                MGNotificationCenter.postNotificationName(MGSwitchRootViewControllerNotification, object: nil, userInfo: ["MGWelcome": "MGWelcomeViewController"])
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        }
        return false
    }
}





