//
//  MGStatusViewModel.swift
//  MGWeibo
//
//  Created by ming on 16/4/1.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGStatusViewModel {
    var status: MGStatus?
    init(status: MGStatus){
        self.status = status
    }
    
    // 1.设置头像
    var iconURL: NSURL?
    {
        guard let urlStrl = status?.user?.profile_image_url else{
            return NSURL()
        }
        return NSURL(string: urlStrl)
    }
    // 2.设置认证用户
    /** -1: 没有认证 0：认证用户 2,3,5：企业认证 220：达人 */
    var verifiedImage: UIImage? {
        guard let type = status?.user?.verified_type else {
            return  nil
        }
        switch type
        {
        case 1:
            return UIImage(named: "avatar_vip")
        case 2,3,5:
            return UIImage(named: "avatar_enterprise_vip")
        case 220:
            return UIImage(named: "avatar_grassroot")
        default:
            return nil
        }
    }
    // 3.设置昵称
    // 4.设置会员图标
    var vipImage: UIImage?{
        if status?.user?.mbrank >= 1 && status?.user?.mbrank < 6
        {
            return UIImage(named: "common_icon_membership_level\(status!.user!.mbrank)")
        }else{
            return nil
        }
    }
    // 5.设置时间
    var timeText: String? {
        guard let timeStr = status?.created_at else{
            return ""
        }
        guard let date = NSDate.dateWithString(timeStr) else {
            return ""
        }
        return date.desStr()
    }
    // 6.设置来源
    var sourceText: String? {
        guard let sourceStr = status?.source else{
            return ""
        }
        if sourceStr == "" { // 对“”进行处理
            return "来自未知"
        }
        let startIndex = (sourceStr as NSString).rangeOfString(">").location + 1
        let length = (sourceStr as NSString).rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
        let res = (sourceStr as NSString).substringWithRange(NSMakeRange(startIndex,length))
        return "来自" + res
    }
//    // 7.用于返回原创或转发的配图
//    var pictures: [MGPicture]? {
//        return status?.retweeted_status != nil ? status?.retweeted_status?.pictures : status?.pictures
//    }
    /// 用于返回原创或者转发的配图
    var pictures: [MGPicture]?
        {
            return status?.retweeted_status != nil ? status?.retweeted_status?.pictures : status?.pictures
    }
    
}