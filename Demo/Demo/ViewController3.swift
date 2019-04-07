//
//  ViewController3.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

var deep = 0

final class CustomNode: TreeNode, Infomation {
    typealias U = CustomNode
    var parent: CustomNode?
    var childs: [CustomNode] = []
    var index: Int = 0
    var length: TreeNodeLength = .eachLength(10)
    var info: Infomation { return self }
    var isFold: Bool = true
    var nodeTitle: String { return "deep:\(currentDeep) - index:\(index)" }
    var nodeDescription: String? {
        return String(describing: self.self)
    }

    init() {
        if deep > 20 { return }
        deep += 1
        
        childs = (0..<Int.random(in: 0...4)).map { num in
            let node = CustomNode()
            node.index = num
            node.parent = self
            return node
        }
    }
}

class ViewController3: UIViewController {

    @IBAction func treeAction(_ sender: Any) {
        deep = 0
        let node1 = CustomNode()
        deep = 0
        let node2 = CustomNode()
        deep = 0
        let node3 = CustomNode()
        let tvc = VerticalTreeListController<CustomNode>(style: UITableView.Style.plain)
        tvc.rootNodes = [node1, node2, node3]
        tvc.startViewTree()
    }
}
