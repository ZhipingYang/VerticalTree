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
    associatedtype NodeValue: TreeNode where Self.NodeValue == Self
    var parent: Self? {get}
    var childs: [Self] {get}
    
    /// current node deep
    /// note: deep start from 1
    var currentDeep: Int {get}
    
    /// the deepest of node tree
    /// note: minimum deep start from 1
    var treeDeep: Int {get}
    
    /// indexViewLegnth
    var length: TreeNodeLength {get}
    
    /// info description
    var info: Infomation {get}
}


// MARK: - helper
extension NSObject: Infomation {
    var title: String {
        return String(describing: self.self)
//        return String(describing: type(of: self))
    }
    var description: String {
        return self.debugDescription
    }
}

extension TreeNode {
    
    func getRootNode<T: TreeNode>(_ currentNode: T) -> T {
        var node: T = currentNode
        while let parent = node.parent {
            node = parent
        }
        return node
    }
    
    func allSubnodes<T: TreeNode>(_ currentNode: T) -> [T] {
        var subnodes = [T]()
        func subnodesBlock(_ node: T) {
            subnodes.append(node)
            node.childs.forEach { subnodesBlock($0) }
        }
        subnodesBlock(currentNode)
        return subnodes
    }
}

