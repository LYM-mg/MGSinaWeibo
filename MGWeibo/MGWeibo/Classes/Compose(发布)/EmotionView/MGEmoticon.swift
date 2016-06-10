//
//  MGEmoticon.swift
//  0-表情键盘
//
//  Created by ming on 16/4/13.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

// MARK:- Emoticon表情模型
/// 表情模型
class MGEmoticon: NSObject,NSCoding{
    /// 当前组文件夹的名称
    var id: String?
    /// 记录当前所用次数
    var count: Int?
    /// 表情名称
    var chs: String?
    /// 表情对应的图片
    var png: String?
        {
        didSet{
            if let _ = png {
                let path: NSString = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
                imagePath = (path.stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
            }
        }
    }
    /// 图片绝对路径
    var imagePath: String?
    
    /// emoji表情的字符串
    var code: String?
        {
        didSet {
            if let _ = code {
                // 1.取出字符串中的十六进制
                let scanner = NSScanner(string: code!)
                var res: UInt32 = 0
                scanner.scanHexInt(&res)
                
                // 2.将十六进制转换成Emoji表情
                let c = Character(UnicodeScalar(res))
                
                // 3.显示Emoji表情
                self.emoji = String(c)
            }
        }
    }
    /// 文字对应的表情
    var emoji: String?
    
    /// 是否是删除按钮
    var isRemoveButton: Bool = false
    init(isRemoveButton: Bool) {
        self.isRemoveButton = isRemoveButton
    }
    
    init(dict: [String: AnyObject], id: String)
    {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    
    override init() {
        super.init()
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }
    
//    override func isEqual(other: AnyObject?) -> Bool {
//        return (self.chs as! NSString).isEqualToString((other as! MGEmoticon).chs!)
//    }
    
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(count, forKey: "count")
        encoder.encodeObject(chs, forKey: "chs")
        encoder.encodeObject(png, forKey: "png")
        encoder.encodeObject(imagePath, forKey: "imagePath")
        encoder.encodeObject(code, forKey: "code")
        encoder.encodeObject(emoji, forKey: "emoji")
    }
    
    // 如果在控件中重写init(frame: CGRect)函数,必须重写init(coder : NSCoder)
    required init?(coder decoder: NSCoder) {
        super.init()
        id = decoder.decodeObjectForKey("id") as? String
        count = decoder.decodeObjectForKey("count") as? Int
        png = decoder.decodeObjectForKey("png") as? String
        chs = decoder.decodeObjectForKey("chs") as? String
        imagePath = decoder.decodeObjectForKey("imagePath") as? String
        code = decoder.decodeObjectForKey("code") as? String
        emoji = decoder.decodeObjectForKey("emoji") as? String
    }
}

//extension MGEmoticon: NSCoding {
//    func encodeWithCoder(encoder: NSCoder) {
//        encoder.encodeObject(id, forKey: "id")
//        encoder.encodeObject(count, forKey: "count")
//        encoder.encodeObject(chs, forKey: "chs")
//        encoder.encodeObject(png, forKey: "png")
//        encoder.encodeObject(imagePath, forKey: "imagePath")
//        encoder.encodeObject(code, forKey: "code")
//        encoder.encodeObject(emoji, forKey: "emoji")
//    }
//
//    // 如果在控件中重写init(frame: CGRect)函数,必须重写init(coder : NSCoder)
//    required init?(coder decoder: NSCoder) {
//        super.init()
//        id = decoder.decodeObjectForKey("id") as? String
//        count = decoder.decodeObjectForKey("count") as? Int
//        png = decoder.decodeObjectForKey("png") as? String
//        chs = decoder.decodeObjectForKey("chs") as? String
//        imagePath = decoder.decodeObjectForKey("imagePath") as? String
//        code = decoder.decodeObjectForKey("code") as? String
//        emoji = decoder.decodeObjectForKey("emoji") as? String
//    }
//}
