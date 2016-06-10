//
//  MGEmotionPackage.swift
//  0-表情键盘
//
//  Created by ming on 16/4/11.
//  Copyright © 2016年 ming. All rights reserved.
//

/*
1.加载emoticons.plist(字典)
|-- (key)packages(字典数组)
|--(key)id (字符串)表情文件夹的名称
2.加载对应文件夹中的info.plist(字典)
|--(key)id(字符串)当前组对应的文件夹名称
|--(key)group_name_cn(字符串)当前组的名称
|--(key)emoticons(字典数组)当前组所有的表情
|--(key)chs(字符串)当前表情的名称, 用于传递给服务器
|--(key)png(字符串)当前表情的图片名称
*/

import UIKit

/// 组模型
class MGEmoticonPackage: NSObject {
    /** 定义属性保存所有组得数据 */
    var packages: [MGEmoticonPackage]?
    /** 当前组文件夹的名称 */
    var id: String?
    /** 当前组所有的表情模型 */
    var emoticons: [MGEmoticon]?
    /** 当前组名称 */
    var group_name_cn: String?
    
    static let MGRecentEmotionsPath = "emotions.archive".doc()
    
    /**
    定义属性保存加载数据
    */
    static var packages: [MGEmoticonPackage]?
    
    init(id: String) {
        self.id = id
    }
    
    /**
    定义方法用户获取所有组的表情数据
    */
    class func loadPackages() -> [MGEmoticonPackage] {
        if packages != nil
        {
            MGLog("直接返回")
            return packages!
        }
//        MGLog("从文件中加载")
        
        var models = [MGEmoticonPackage]()
        // 0.添加最近组
        let package = MGEmoticonPackage(id: "")
     
        if let emoticons = NSKeyedUnarchiver.unarchiveObjectWithFile(MGRecentEmotionsPath) as? [MGEmoticon]  {
            package.emoticons = emoticons
//            print(emoticons)
        }

        package.appendEmptyEmoticons()
        models.append(package)
        
        // 1.获取plist路径
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 2.加载emoticons.plist
        let dict = NSDictionary(contentsOfFile: path)!
        // 3.获取所有组的字典
        let packagesDict = dict["packages"] as! [[String: AnyObject]]
        
        // 4.遍历字典中的每一组数据
        for packageDict in packagesDict {
            // 4.1创建对应的组模型
            let idStr = packageDict["id"] as! String
            let package = MGEmoticonPackage(id: idStr)
            models.append(package)
            // 4.2加载对应组中的表情
            package.loadEmoticons()
            // 4.3追加空白模型(保证每一组占用完整的一页)
            package.appendEmptyEmoticons()
        }
        return models
    }
    
    /**
    加载当前组所有表情模型
    */
    private func loadEmoticons() {
        // 1.获取plist路径
        let path: NSString = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
        let emoticonPath = (path.stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent("info.plist")
        // 2.加载info.plist
        let dict = NSDictionary(contentsOfFile: emoticonPath)!
        group_name_cn = dict["group_name_cn"] as? String
        let emoticonsDict = dict["emoticons"] as! [[String: AnyObject]]
        // 3.获取所有组的字典
        var models = [MGEmoticon]()
        var index: Int = 0
        for emoticonDict in emoticonsDict
        {
            let emoticon = MGEmoticon(dict: emoticonDict, id: id!)
            models.append(emoticon)
            index++
            if index == 20 {
                // 追加一个删除按钮
                models.append(MGEmoticon(isRemoveButton: true))
                index = 0
            }
        }
        emoticons = models
    }
    
    private func appendEmptyEmoticons(){
        if emoticons == nil {
            emoticons = [MGEmoticon]()
            emoticons?.append(MGEmoticon(isRemoveButton: false))
        }
        
        // 18 % 21 = 18
        let count = emoticons!.count % 21
        if count > 0 {
            for _ in count..<20
            {
                emoticons?.append(MGEmoticon(isRemoveButton: false))
            }
            emoticons?.append(MGEmoticon(isRemoveButton: true))
        }
    }
    
    // 将使用过的标签最近表情界面
    func appendRecentEmoticons(emoticon: MGEmoticon){
        let contains = emoticons!.contains(emoticon)
        if !contains {
            // 删除重复的表情
//            emoticons?.remove
            emoticons?.removeLast()
            emoticons?.insert(emoticon, atIndex: 0)
        }
        
        let res = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.count > e2.count
        })
        emoticons = res
        
        // 3.拼接删除按钮
//        emoticons?.append(MGEmoticon(isRemoveButton: true))
        emoticons?.removeLast()
        emoticons?.insert(MGEmoticon(isRemoveButton: true), atIndex: 20)
        
        // 4.存储到本地
        NSKeyedArchiver.archiveRootObject(emoticons!, toFile: MGEmoticonPackage.MGRecentEmotionsPath)
//        MGLog(MGRecentEmotionsPath)
    }

}

// MARK:-
extension MGEmoticonPackage {
    /**
    根据普通字符串生成表情字符
    */
    class func emotionAttributedText(str: String) -> NSAttributedString
    {
        // 1.创建规则
        let pattern = "\\[.*?\\]"
        
        // 2.根据规则创建正则表达式对象
        let regex = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
        
        // 3.利用正则表达式对象取出结果
        let arr = regex.matchesInString(str, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        
        let strM = NSMutableAttributedString(string: str)
        
        // 4.生成属性字符串
        var count = arr.count
        
        while count > 0
        {
            let res = arr[--count]
            // 4.1获取表情字符串
            let temp = (str as NSString).substringWithRange(res.range)
            // 4.2根据表情字符串获取表情模型
            if let emoticon = emoticonWithStr(temp)
            {
                // 4.3生成表情属性字符串
                let str = MGEmoticonTextAttachment.emoticonAttributedString(emoticon, font: UIFont.systemFontOfSize(20))
                
                // 4.4利用表情属性字符串, 替换表情字符串
                // 数据替换混乱原因
                //     {2,4}  {8,5}
                // 我们[爱你]大家[笑嘻嘻]了
                strM.replaceCharactersInRange(res.range, withAttributedString: str)
            }
        }
        return strM
    }
    
    /**
    根据指定表情字符串查找对应的表情模型
    
    - parameter str: 表情字符串
    
    - returns: 表情模型
    */
    private class func emoticonWithStr(str: String) -> MGEmoticon?
    {
        // 1.取出所有的组
        let packages = MGEmoticonPackage.loadPackages()
        var emoticon: MGEmoticon?
        // 2.遍历所有组
        for package in packages
        {
            // 3.遍历当前组所有的模型
            emoticon = package.emoticons?.filter({ (e) -> Bool in
                return e.chs == str
            }).last
            
            // 4.判断是否还需要继续查找
            if emoticon != nil
            {
                break
            }
        }
        return emoticon
    }
}
