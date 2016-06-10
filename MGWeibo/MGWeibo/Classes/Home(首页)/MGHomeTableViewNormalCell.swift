//
//  MGHomeTableViewNormalCell.swift
//  MGWeibo
//
//  Created by ming on 16/4/7.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGHomeTableViewNormalCell: MGHomeTableViewCell {

    override var viewModel: MGStatusViewModel? {
        didSet {
            // 1.调整配图位置
            let offset = viewModel?.pictures?.count == 0 ? 0 : 15
            pictureView.snp_updateConstraints { (make) -> Void in
                make.top.equalTo(contentTextLabel.snp_bottom).offset(offset)
            }
        }
    }
}
