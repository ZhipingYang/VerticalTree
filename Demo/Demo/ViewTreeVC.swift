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
        let wrapper = NodeWrapper(obj: _view)//.changeProperties({ $0.length = .eachLength(5) })
        let tvc = VerticalTreeListController(source: wrapper)
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
        
        cell?.toView.getRoot.prettyPrint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // windows
        view.getRoot.prettyPrint()
        
        // view layer
        tableView.layer.prettyPrint()
    }
}
