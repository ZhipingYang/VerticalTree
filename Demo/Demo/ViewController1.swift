//
//  ViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController1: UITableViewController {
    
    lazy var tvc: VerticalTreeListController<NodeWrapper<UIView>> = {
        let tvc = VerticalTreeListController<NodeWrapper<UIView>>(style: .plain)
        tvc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target:self, action: #selector(dismissWindows))
        return tvc
    }()
    
    @IBAction func actionSelector(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        let rootNode = NodeWrapper(obj: _view)
        tvc.rootNodes = [rootNode]
        tvc.startViewTree()
    }
    
    @objc func dismissWindows() {
        tvc.endViewTree()
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
