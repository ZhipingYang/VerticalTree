//
//  ViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    lazy var windows: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .statusBar - 0.1
        let nav = UINavigationController(rootViewController: tvc)
        window.rootViewController = nav
        return window
    }()
    
    var tvc = IndexTreeTableController<ViewTreeNode>(style: UITableView.Style.plain)

    @IBAction func actionSelector(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        tvc.source = ViewTreeNode(_view)
        windows.isHidden = false
        windows.makeKeyAndVisible()
    }
}

