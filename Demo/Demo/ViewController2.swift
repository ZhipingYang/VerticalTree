//
//  ViewController2.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBAction func treeAction(_ sender: Any) {
        let tvc = VerticalTreeListController(source: NodeWrapper(obj: self.tabBarController!))
        tvc.startViewTree()
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
