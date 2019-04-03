//
//  IndexTreeProtocol.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/21.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

/// index width
///
/// - eachWidth: eachWidth of the next node
/// - IndexWidth: whole width of indexView
enum TreeNodeLength {
    case eachLength(_ length: CGFloat)
    case indexLength(_ length: CGFloat)
}

/// Node info
protocol Infomation {
    var title: String {get}
    var description: String {get}
}

/// Node protocol
protocol TreeNode {
//    associatedtype NodeValue: TreeNode
    var parent: TreeNode? {get}
    var childs: [TreeNode] {get}
    
    /// current node deep
    /// note: deep start from 1
    var currentDeep: Int {get}
    
    /// the deepest of node tree
    /// note: minimum deep start from 1
    var treeDeep: Int {get}
    var index: Int {get}
    
    /// indexViewLegnth
    var length: TreeNodeLength {get}
    
    /// info description
    var info: Infomation {get}
}


// MARK: - helper
extension NSObject: Infomation {
    var title: String {
//        return String(describing: self.self)
        return String(describing: type(of: self))
    }
    var description: String {
        return self.debugDescription
    }
}

extension TreeNode {
    
    func getRootNode() -> Self {
        var node = self
        while let parent = node.parent {
            node = parent as! Self
        }
        return node
    }
    
    func allSubnodes() -> [Self] {
        var subnodes = [Self]()
        func subnodesBlock(_ node: Self) {
            subnodes.append(node)
            node.childs.forEach { subnodesBlock($0 as! Self) }
        }
        subnodesBlock(self)
        return subnodes
    }
    
    var haveChild: Bool {
        return self.childs.count > 0
    }
    
    var haveParent: Bool {
        return self.parent != nil
    }
    
    var haveNext: Bool {
        return self.index < (self.parent?.childs.count ?? 1) - 1
    }
}
