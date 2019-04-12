//
//  ViewController2.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import VerticalTreeView

class ControllerTreeVC: UIViewController {
    
    let vc1 = UIViewController()
    let vc2 = UIInputViewController()
    
    @IBAction func treeAction(_ sender: Any) {
        let tvc = VerticalTreeListController(source: NodeWrapper(obj: self.tabBarController!))
        tvc.startViewTree()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(vc1)
        addChild(vc2)        
    }
}

extension UIViewController: BaseTree {
    public var parent: UIViewController? {
        return self.parentVC
    }
    public var childs: [UIViewController] {
        return children
    }
}

extension UIResponder {
    var parentVC: UIViewController? {
        let seq = sequence(first: self.next) { $0?.next }
        return seq.first { $0 is UIViewController } as? UIViewController
    }
}
