//
//  ViewController2.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    lazy var windows: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .statusBar - 0.1
        let nav = UINavigationController(rootViewController: tvc)
        window.rootViewController = nav
        return window
    }()
    
    lazy var tvc: VerticalTreeListController<NodeWrapper<UIViewController>> = {
        let tvc = VerticalTreeListController<NodeWrapper<UIViewController>>(style: .plain)
        tvc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target:self, action: #selector(dismissWindows))
        return tvc
    }()

    @IBAction func treeAction(_ sender: Any) {
        let rootNode = NodeWrapper(obj: self.tabBarController!)
        tvc.rootNodes = [rootNode]
        windows.isHidden = false
        windows.makeKeyAndVisible()
    }
    
    @objc func dismissWindows() {
        windows.isHidden = true
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (0...10).forEach {
            if $0%2 == 0 {
                addChild(UIViewController())
            } else {
                addChild(UIInputViewController())
            }
        }
    }
}

extension UIViewController: BaseTree {
    var parent: UIViewController? {
        return presentedViewController
    }
    var childs: [UIViewController] {
        return children
    }
}
