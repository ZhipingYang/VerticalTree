//
//  ViewController2.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import VerticalTree

class ControllerTreeVC: UIViewController {
    
    let vc1 = UIViewController()
    let vc2 = UIInputViewController()
    var wrapper: NodeWrapper<UIViewController>?
    
    @IBAction func treeAction(_ sender: Any) {
        VerticalTreeListController(source: wrapper!).startViewTree()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(vc1)
        addChild(vc2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wrapper = NodeWrapper(obj: getTreeRoot).changeProperties {
            $0.length = .eachLength(20)
            guard let targetVC = $0.obj else { return }
            var nodeDescription = targetVC.description
            let viewState = " viewState: \(targetVC.isViewLoaded ? ( targetVC.view.window != nil ? "appeared" : "disappeared_but_loaded") : "unloaded")"
            let view = " view: \(targetVC.isViewLoaded ? String(describing: targetVC.self) : "(view not load)")"
            let lastIndex = nodeDescription.index(nodeDescription.startIndex, offsetBy: nodeDescription.count-1)
            nodeDescription.insert(contentsOf: viewState + view, at: lastIndex)
            $0.nodeDescription = nodeDescription
        }

        // wrapper's way
        print(wrapper!.treePrettyText(true))
        
        // VC extension
        getTreeRoot.treePrettyPrint(inDebug: true)
        
        // LLDB's way
        print(tabBarController!.value(forKey: "_printHierarchy")!)
    }
}
