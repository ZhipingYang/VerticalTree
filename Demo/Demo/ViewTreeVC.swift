//
//  ViewTreeVC.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import VerticalTree

class ViewTreeVC: UITableViewController {
    
    @IBAction func showViewTreeAction(_ sender: Any) {
        let _view: UIView = view.window ?? navigationController?.view ?? view
        let wrapper = NodeWrapper(obj: _view)
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
        
        // console log, mark cell struct in the tableview struct
        cell?.treePrettyText(ofTop: view, inDebug: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let cell = tableView.visibleCells.first
        
        // windows
        cell?.treePrettyPrint(inDebug: true)
        
        // view layer
        cell?.layer.treePrettyPrint()
    }
}
