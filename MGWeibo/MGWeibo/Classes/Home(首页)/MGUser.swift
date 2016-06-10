//
//  MGUser.swift
//  MGWeibo
//
//  Created by ming on 16/3/31.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGUser: NSObject {
    /** 字符串的用户ID */
    var idstr: String?
    /** 用户昵称 */
    var screen_name: String?
    /** 用户的图像地址（中图）50x50像素 */
    var profile_image_url: String?
    /** 认证类型 */
    var verified_type: Int?
    /** 微博等级 */
    var mbrank: Int?
    
    init(dict:[String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let peoperty = ["idstr","screen_name","profile_image_url","verified_type"]
        let dict = dictionaryWithValuesForKeys(peoperty)
        return "\(dict)"
    }
}


/*
"user": {
    "id": 1941566050,
    "idstr": "1941566050",
    "class": 1,
    "screen_name": "WindZero-肖峰",
    "name": "WindZero-肖峰",
    "province": "44",
    "city": "14",
    "location": "广东 梅州",
    "description": "喜爱五叶神的少年",
    "url": "",
    "profile_image_url": "http://tp3.sinaimg.cn/1941566050/50/5713070329/1",
    "cover_image_phone": "http://ww4.sinaimg.cn/crop.0.0.640.640.640/6ce2240djw1e8iktk4ohij20hs0hsmz6.jpg",
    "profile_url": "525679881",
    "domain": "",
    "weihao": "525679881",
    "gender": "m",
    "followers_count": 612,
    "friends_count": 17,
    "pagefriends_count": 0,
    "statuses_count": 1378,
    "favourites_count": 10,
    "created_at": "Mon Feb 21 17:02:18 +0800 2011",
    "following": true,
    "allow_all_act_msg": false,
    "geo_enabled": true,
    "verified": true,
    "verified_type": 0,
    "remark": "肖峰",
    "ptype": 0,
    "allow_all_comment": true,
    "avatar_large": "http://tp3.sinaimg.cn/1941566050/180/5713070329/1",
    "avatar_hd": "http://tva4.sinaimg.cn/crop.0.0.757.757.1024/73b9f262jw8en3d86da3gj20l10l20uy.jpg",
    "verified_reason": "广东水利电力职业技术学院梅州同乡会 会长",
    "verified_trade": "3356",
    "verified_reason_url": "",
    "verified_source": "",
    "verified_source_url": "",
    "verified_state": 0,
    "verified_level": 3,
    "verified_reason_modified": "",
    "verified_contact_name": "",
    "verified_contact_email": "",
    "verified_contact_mobile": "",
    "follow_me": false,
    "online_status": 0,
    "bi_followers_count": 4,
    "lang": "zh-cn",
    "star": 0,
    "mbtype": 2,
    "mbrank": 5,
    "block_word": 0,
    "block_app": 0,
    "credit_score": 80,
    "user_ability": 0,
    "urank": 19
},
*/