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

    lazy var tvc: VerticalTreeListController<ViewTreeNode> = {
        let tvc = VerticalTreeListController<ViewTreeNode>(style: .plain)
        tvc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target:self, action: #selector(dismissWindows))
        return tvc
    }()
    
//    let tvc = DemoVerticalTreeController<ViewTreeNode>()

    @IBAction func actionSelector(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        tvc.rootNodes = [ViewTreeNode(view: tableView.visibleCells.first!), ViewTreeNode(view: _view)]
        windows.isHidden = false
        windows.makeKeyAndVisible()
    }
    
    @objc func dismissWindows() {
        windows.isHidden = true
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
}

