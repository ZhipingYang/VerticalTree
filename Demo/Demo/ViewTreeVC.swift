//
//  ViewTreeVC.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import VerticalTreeView

class ViewTreeVC: UITableViewController {
    
    @IBAction func showViewTreeAction(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        let tvc = VerticalTreeListController(source: NodeWrapper(obj: _view))
        tvc.startViewTree()
    }
    
    @IBAction func showLayerTreeAction(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        let tvc = VerticalTreeListController(source: NodeWrapper(obj: _view.layer))
        tvc.startViewTree()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        let wrapper = NodeWrapper(obj: cell!)
        let vc = VerticalTreeListController(source: wrapper)
        vc.startViewTree()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NodeWrapper(obj: self.view).allSubnodes().forEach { node in
            print(node.prettyPrint())
        }
    }
}

extension CALayer: BaseTree {
    public var parent: CALayer? {
        return superlayer
    }
    public var childs: [CALayer] {
        return sublayers ?? []
    }
}

extension UIView: BaseTree {
    public var parent: UIView? {
        return superview
    }
    public var childs: [UIView] {
        return subviews
    }
}
