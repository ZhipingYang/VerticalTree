//
//  ViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController1: UITableViewController {
    
    @IBAction func actionSelector(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        let tvc = VerticalTreeListController(source: NodeWrapper(obj: _view))
        tvc.startViewTree()
    }
}

extension UIView: BaseTree {
    var parent: UIView? {
        return superview
    }
    var childs: [UIView] {
        return subviews
    }
}
