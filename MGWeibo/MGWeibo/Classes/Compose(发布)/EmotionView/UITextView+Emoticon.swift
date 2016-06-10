//
//  UITextView+Emoticon.swift
//  0-表情键盘
//
//  Created by ming on 16/4/12.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
    *   根据光标插入一个表情字符串
    */
    func insertEmoticon(emoticon: MGEmoticon)
    {
        // 零、点击是删除按钮
        if emoticon.isRemoveButton == true {
            deleteBackward()
            return
        }
        
        // 一、表情文字
        if let emoticonStr = emoticon.emoji {
            replaceRange(selectedTextRange!, withText: emoticonStr)
        }
        
        // 二、表情图片
        if let _ = emoticon.chs {
            // 1.创建一个附件
            // 2.根据附件创建一个表情字符串
            // 表情字符串有自己默认的大小
            let str = MGEmoticonTextAttachment.emoticonAttributedString(emoticon, font: font!)
            
            // 3.根据UITextView里面的内容生成一个表情属性字符串容器
            let strM = NSMutableAttributedString(attributedString: attributedText)
            
            // 4.将表情字符串替换光标所在位置
            let range = selectedRange
            strM.replaceCharactersInRange(range, withAttributedString: str)
            
            // 5.设置被替换掉的字符串的大小
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(range.location, 1))
            
            // 6.将属性字符串的内容替换到UITextView
            attributedText = strM
            
            // 7.将光标插入到表情的后面
            selectedRange = NSMakeRange(range.location + 1, 0)
            
            // 8.手动触发textViewDidChange
            delegate?.textViewDidChange!(self)
        }
    }
    
    /**
    *   遍历里面的内容
    *
    *   - return: String 返回字符串
    */
    func emoticonString() -> String
    {
        var strM = ""
        attributedText.enumerateAttributesInRange(NSMakeRange(0,  attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            
                if let attachment = dict["attachment"] as? MGEmoticonTextAttachment {
                    strM +=  attachment.chs!
                }else {
                    let str = (self.attributedText.string as NSString).substringWithRange(range)
                    strM += str
                }
        }
        return strM
    }
}