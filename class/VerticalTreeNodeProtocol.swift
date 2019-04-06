//
//  IndexTreeProtocol.swift
//  VerticalTreeIndexView
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
    var nodeTitle: String {get}
    var nodeDescription: String? {get}
}

/// Node protocol
protocol TreeNode {
    associatedtype NodeValue: TreeNode where Self.NodeValue == Self
    var parent: NodeValue? {get}
    var childs: [NodeValue] {get}
    
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
    
    var isFold: Bool {set get}
}


// MARK: - helper
extension Infomation where Self: NSObject {
    
    var nodeTitle: String {
        return String(describing: type(of: self))
    }
    
    var nodeDescription: String? {
        return String(describing: self.self)
    }
}

extension TreeNode {
    
    var currentDeep: Int {
        var deep = 1
        var node = self
        while let p = node.parent {
            deep += 1
            node = p
        }
        return deep
    }
    
    var treeDeep: Int {
        return getRootNode().allSubnodes().max {$0.currentDeep < $1.currentDeep }?.currentDeep ?? 1
    }
}

extension TreeNode {

    func getRootNode() -> Self {
        var node = self
        while let parent = node.parent {
            node = parent
        }
        return node
    }
    
    func allSubnodes(_ includeSelf: Bool = true) -> [Self] {
        var subnodes = [Self]()
        func subnodesBlock(_ node: Self) {
            subnodes.append(node)
            node.childs.forEach { subnodesBlock($0) }
        }
        if includeSelf {
            subnodesBlock(self)
        } else {
            childs.forEach { subnodesBlock($0) }
        }
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
