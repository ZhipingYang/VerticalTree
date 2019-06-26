//
//  CustomTreeVC.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import VerticalTree
import Then

var deep = 0

final class CustomNode: NSObject, VerticalTreeNode {
    var parent: CustomNode?
    var childs: [CustomNode] = []
    var indexPath: IndexPath
    var length: TreeNodeLength = .each(10)
    var info: Infomation { return self }
    var isFold: Bool = true
    var nodeTitle: String { return "indexPath:\(indexPath)" }
    var nodeDescription: String? {
        return String(describing: self.self)
    }

    init(indexPath: IndexPath = IndexPath(index: 0)) {
        self.indexPath = indexPath
        super.init()
        
        if deep > 20 { return }
        deep += 1
        
        childs = (0..<Int.random(in: 0...3)).map {
            CustomNode(indexPath: indexPath.appending($0)).then { $0.parent = self }
        }
    }
}

class CustomTreeVC: UIViewController {
    
    var rootNodes = [CustomNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    private func update() {
        deep = 0
        let node1 = CustomNode()
        deep = 0
        let node2 = CustomNode()
        deep = 0
        let node3 = CustomNode()
        rootNodes = [node1, node2, node3]
    }
    
    @IBAction func treeAction(_ sender: Any) {
        update()
        
        let tvc = VerticalTreeListController<CustomNode>(style: UITableView.Style.plain)
        tvc.rootNodes = rootNodes
        tvc.startViewTree()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootNodes.forEach { print($0.subTreePrettyText()) }
    }
}
