//
//  MGPopViewController.swift
//  MGWeibo
//
//  Created by ming on 16/3/24.
//  Copyright © 2016年 ming. All rights reserved.
//

import UIKit

class MGPopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension MGPopViewController :UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let groupCell = "groupCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(groupCell)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: groupCell)
        }
        
        cell?.textLabel?.text = "明明就是你"
        
        return cell!
    }
}
