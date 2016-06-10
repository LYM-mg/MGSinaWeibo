//
//  MGStatus.swift
//  MGWeibo
//
//  Created by ming on 16/3/29.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGStatus: NSObject {
    /** 微博创建时间 */
    var created_at: String?
    /** 微博ID */
    var idstr: String?
    /** 当前微博内容 */
    var text: String?
    /** 当前微博来源 */
    var source: String?
    /** 当前微博对应用户 */
    var user: MGUser?
    /** 当前微博对应配图 */
    var pictures: [MGPicture]?
    
    var retweeted_status: MGStatus?
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        // 1.判断当前取出的key是否是用户
        if key == "user" {
            // 如果是用户就自己处理
            user = MGUser(dict: value as! [String: AnyObject])
            return
        }
        // 2.判断当前是否有配图
        if key == "pic_urls" {
            // 如果是图片就自己处理
            var models = [MGPicture]()
            for dict in value as! [[String: AnyObject]] {
                models.append(MGPicture(dict: dict))
            }
            pictures = models
            return
        }
        // 3.判断当前是否转发微博
        if key == "retweeted_status" {
            retweeted_status = MGStatus(dict: value as! [String: AnyObject])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override var description: String {
        let peoperty = ["created_at","idstr","text","source"]
        let dict = dictionaryWithValuesForKeys(peoperty)
        return "\(dict)"
    }
}

/*
{
"created_at": "Tue Mar 29 00:58:23 +0800 2016",
"id": 3958168210388949,
"mid": "3958168210388949",
"idstr": "3958168210388949",
"text": "#射雕英雄传3D#江湖烽烟四起，金庸正版授权武侠动作RPG《射雕英雄传3D》3月17日震撼来袭——射雕原汁原味剧情，江湖武功秘籍，轻松收集郭靖、黄蓉，更有五绝在等你！这一刻，你就是大侠！江湖等你来战！http://t.cn/RG1exVR",
"textLength": 207,
"source_allowclick": 0,
"source_type": 1,
"source": "<a href=\"http://app.weibo.com/t/feed/1fOgu\" rel=\"nofollow\">老虎游戏</a>",
"favorited": false,
"truncated": false,
"in_reply_to_status_id": "",
"in_reply_to_user_id": "",
"in_reply_to_screen_name": "",
"pic_urls": [
{
"thumbnail_pic": "http://ww2.sinaimg.cn/thumbnail/73b9f262jw1f2d2g8u1o9j20c80fa75j.jpg"
}
],
"thumbnail_pic": "http://ww2.sinaimg.cn/thumbnail/73b9f262jw1f2d2g8u1o9j20c80fa75j.jpg",
"bmiddle_pic": "http://ww2.sinaimg.cn/bmiddle/73b9f262jw1f2d2g8u1o9j20c80fa75j.jpg",
"original_pic": "http://ww2.sinaimg.cn/large/73b9f262jw1f2d2g8u1o9j20c80fa75j.jpg",
"geo": null,
"reposts_count": 0,
"comments_count": 0,
"attitudes_count": 0,
"isLongText": false,
"mlevel": 0,
"visible": {
"type": 0,
"list_id": 0
},
"biz_feature": 0,
"page_type": 32,
"darwin_tags": [ ],
"hot_weibo_tags": [ ],
"text_tag_tips": [ ],
"rid": "0_0_1_2666887134319964402",
"userType": 0
}
*/
