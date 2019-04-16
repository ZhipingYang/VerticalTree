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
public enum TreeNodeLength {
    case eachLength(_ length: CGFloat)
    case indexLength(_ length: CGFloat)
}

/// Node info
public protocol Infomation {
    var nodeTitle: String {get}
    var nodeDescription: String? {get}
}

public protocol BaseTree {
    associatedtype T: BaseTree
    var parent: T? {get}
    var childs: [T] {get}
}

/// Node protocol
public protocol TreeNode: BaseTree {
    associatedtype U: TreeNode where Self.U == Self
    var parent: U? {get}
    var childs: [U] {get}
    
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
extension Infomation where Self: NSObjectProtocol {
    
    public var nodeTitle: String {
        return String(describing: type(of: self))
    }
    
    public var nodeDescription: String? {
        return String(describing: self.self)
    }
}

extension TreeNode {
    
    public var currentDeep: Int {
        var deep = 1
        var node = self
        while let p = node.parent {
            deep += 1
            node = p
        }
        return deep
    }
    public var treeDeep: Int {
        return getRootNode().allSubnodes().max {$0.currentDeep < $1.currentDeep }?.currentDeep ?? 1
    }
}

extension TreeNode {

    public func getRootNode() -> Self {
        let seq = sequence(first: self) { $0.parent }
        return seq.first(where: { $0.parent == nil })!
    }
    
    public func allSubnodes(_ includeSelf: Bool = true) -> [Self] {
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
    
    public var haveChild: Bool {
        return self.childs.count > 0
    }
    
    public var haveParent: Bool {
        return self.parent != nil
    }
    
    public var haveNext: Bool {
        return self.index < (self.parent?.childs.count ?? 1) - 1
    }
}
