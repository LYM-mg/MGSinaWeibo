//
//  MGEmoticonTextAttachment.swift
//  0-表情键盘
//
//  Created by ming on 16/4/12.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGEmoticonTextAttachment: NSTextAttachment {
    // 当前杜建对应的字符串
    var chs: String?

    /**
    *   根据一个附件创建一个表情字符串
    *   - parameter emoticon: 表情模型
    *   - return: NSAttributedString表情字符体
    */
    class func emoticonAttributedString(emoticon: MGEmoticon, font: UIFont) -> NSAttributedString {
        //
        let attachment = MGEmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        let s = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -3, width: s, height: s)
        
        // 2.根据附件创建一个表情字符串
        // 表情字符串有自己默认的大小
        return NSAttributedString(attachment: attachment)
    }
}
