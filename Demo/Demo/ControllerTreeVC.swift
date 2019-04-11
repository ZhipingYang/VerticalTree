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
        view.addSubview(vc1.view)
        view.addSubview(vc2.view)
        
        print(NodeWrapper<UIViewController>(obj: self.tabBarController!).allSubnodes().map {
            $0.info.nodeTitle
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        var resp = self
        while let next = resp.next {
            resp = next
            if next.isKind(of: UIViewController.self) {
                return next as? UIViewController
            }
        }
        return nil
    }
}
