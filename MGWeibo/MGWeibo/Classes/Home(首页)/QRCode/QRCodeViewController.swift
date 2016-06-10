//
//  QRCodeViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    // MARK:- storyboard拖线属性
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var borderView: UIImageView!
    @IBOutlet weak var scanView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var containViewHCon: NSLayoutConstraint!
    @IBOutlet weak var scanViewTopCon: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var session : AVCaptureSession? // 会话
    var preViewlayer : AVCaptureVideoPreviewLayer? // 预览图层
    var shapeLayer : CAShapeLayer? // 画形状的layer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.让Tabbar默认选择第0个
        tabBar.selectedItem = tabBar.items![0]
        
        // 2.添加扫描动画
        setUpScanAnimation()
        
        // 3.开始扫描
        startScanning()
    }
    
    // MARK:- 自定义方法
    /// 开始动画
    private func startScanning() {
        // 1.创建会话
        let session = AVCaptureSession()
        self.session = session
        
        // 2.设置会话输入
        let device = AVCaptureDevice.defaultDeviceWithMediaType("AVMediaTypeVideo")
//        let input = try ? AVCaptureDeviceInput(device: device)
        guard let input = try? AVCaptureDeviceInput(device: device) else{
            print("没有输入设备")
            return
        }
        session.addInput(input)
        
        // 3.设置会话输出
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        
        // 4.设置图层
        let preViewLayer = AVCaptureVideoPreviewLayer()
        preViewLayer.frame = view.frame
        view.layer.insertSublayer(preViewLayer, atIndex: 0)
        self.preViewlayer = preViewLayer
        
        // 5.开始扫描
        session.startRunning()
    }
    
    /// 冲击波动画(扫描动画)
    private func setUpScanAnimation() {
        scanViewTopCon.constant = -containViewHCon.constant
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.scanViewTopCon.constant = self.containViewHCon.constant
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK:- 操作
    /// 点击左边关闭按钮的操作
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 点击导航栏右边照片的操作
    @IBAction func photoItemClick(sender: AnyObject) {
        // 1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            print("照片库不可用")
        }
        
        // 2.创建ipc
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .PhotoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 5.弹出控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
}

// MARK:- <AVCaptureMetadataOutputObjectsDelegate>的代理方法
extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate {
    /// 拿到输出结果
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        guard let object = metadataObjects.last as? AVMetadataMachineReadableCodeObject else{
            print("没有获取到扫描结果")
            return
        }
        
         // 2.获取扫描结果并且显示出来
        self.resultLabel.text = object.stringValue
        
        
        // 3.使用预览图层,将corners的点转成坐标系中的点
        guard let newObject = preViewlayer?.transformedMetadataObjectForMetadataObject(object) as? AVMetadataMachineReadableCodeObject else{
            print("没有将corners的点转成坐标系中的点成功")
            return
        }
        
        // 4.画边框
        drawBorder(newObject)
    }
    
     /// 画边框
    private func drawBorder(object:AVMetadataMachineReadableCodeObject){
        // 0.移除之前的图形
        self.shapeLayer?.removeFromSuperlayer()
        
        // 1.创建CAShapeLayer(形状类型:专门用于画图)
        let shapeLayer = CAShapeLayer()
        
        // 2.设置layer属性
        shapeLayer.borderColor = UIColor.orangeColor().CGColor
        shapeLayer.borderWidth = 5;
        shapeLayer.fillColor = UIColor.redColor().CGColor
        
        // 3.创建贝塞尔曲线
        let path = UIBezierPath()
        
        // 4.给贝塞尔曲线添加对应的点
        for i in 0..<object.corners.count {
            // 4.1获取每一个点对应的字典
            let dict = object.corners[i] as! CFDictionary
            var point = CGPointZero
            CGPointMakeWithDictionaryRepresentation(dict, &point)
            
            // 4.2如果是第一个点,移动到第一个点
            if i == 1 {
                path.moveToPoint(point)
                continue
            }
            
            // 4.3如果是其他的点,则添加线
            path.addLineToPoint(point)
        }
        
        // 5闭合path路径
        path.closePath()
        
        // 6.给shapeLayer添加路径
        shapeLayer.path = path.CGPath
        
        // 7.将shapeLayer添加到其他视图上
        preViewlayer?.addSublayer(shapeLayer)
        
        // 8.保存shapeLayer
        self.shapeLayer = shapeLayer
    }
}

// MARK:- <UIImagePickerControllerDelegate,UINavigationControllerDelegate>的代理方法
extension QRCodeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            print("没有获取到照片")
            return
        }
        
        // 2.识别照片中的二维码的信息
        getQRCodeInfo(image)
        
        // 3.退出控制器
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private func getQRCodeInfo(image:UIImage) {
        // 1.创建扫描器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        // 2.扫描结果
        guard let ciImage = CIImage(image: image) else {
            print("转ciImage失败")
            return
        }
        
        let features = detector.featuresInImage(ciImage)
        
        // 3.遍历扫描结果
        for f in features {
            guard let feature = f as? CIQRCodeFeature else {
                continue
            }
            print(feature.messageString)
        }
    }
}

// MARK:- <UITabBarDelegate>的代理方法
extension QRCodeViewController:UITabBarDelegate {
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        // 1.修改内容view的高度
        containViewHCon.constant = tabBar.tag == 1 ? 250 : 120
        view.layoutIfNeeded()
        
        // 2.移除之前动画
        scanView.layer.removeAllAnimations()
        
        // 3.调用之前的冲击波动画
        setUpScanAnimation()
        
        // 4.调用之前的开始扫描动画
        startScanning()
    }
}


