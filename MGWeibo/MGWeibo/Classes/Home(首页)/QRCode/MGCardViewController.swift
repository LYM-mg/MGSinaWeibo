//
//  MGCardViewController.swift
//  MGWeibo
//
//  Created by ming on 16/1/9.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGCardViewController: UIViewController {

    // MARK:- 脱线属性
    @IBOutlet weak var qrCodeView: UIImageView!
    
    // MARK:- 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpQRCode()
    }
    
    // MARK:- 自定义方法
    /// 创建二维码照片
    private func setUpQRCode() {
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.设置滤镜为默认模式
        filter?.setDefaults()
        
        // 3.设置滤镜输入
        let qrcodeInfo = "http://it520.com"
        guard let qrcodeInfoData = qrcodeInfo.dataUsingEncoding(NSUTF8StringEncoding) else {
            print("字符串转换成data数据失败")
            return
        }
        filter?.setValue(qrcodeInfoData, forKeyPath: "inputMessage")
       
        // 4.获取产生的图片
        guard let outputImage = filter?.outputImage else {
            print("没有生成outputImage")
            return
        }
        
        // 5.设置图片
        let image = scaleImage(outputImage)
        
        // 6.在二维码中画上头像
        qrCodeView.image = drawImage(image, iconName: "12")
    }
    
    /// 拉伸图片,去除生成的二维码模糊的BUG
    private func scaleImage(imgae : CIImage) ->UIImage {
        let transform = CGAffineTransformMakeScale(10, 10)
        
        let newImage = imgae.imageByApplyingTransform(transform)
        
        return UIImage(CIImage: newImage)
    }
    
    /// 画图片,利用Quartz2D,在二维码中间生成一张小图片
    private func drawImage(image : UIImage, iconName: String) ->UIImage {
        // 1.开启位图文
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        
        // 2.渲染
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        // 3.将传入进来的image绘画上去
        image.drawInRect(CGRect(origin: CGPointZero, size: image.size))
//        image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        // 4.计算中间图片的大小以及放图片进去的矩形框
        let centerImage = UIImage(named: iconName)
        
        let width:CGFloat = 60
        let height:CGFloat = 60
        let x = (image.size.width - width)/2
        let y = (image.size.height - height)/2
        
        centerImage?.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        // 5.获得当前感图片
        let drawImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 6.结束(关闭)图形上下文
        UIGraphicsEndImageContext()
        
        // 7.返回绘制好的图片
        return drawImage
    }

}
