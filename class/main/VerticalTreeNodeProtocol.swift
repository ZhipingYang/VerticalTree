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

// MARK: - Node info

/// show the node info
public protocol Infomation {
    var nodeTitle: String { get }
    var nodeDescription: String? { get }
}
extension Infomation where Self: NSObjectProtocol {
    public var nodeTitle: String {
        return String(describing: type(of: self))
    }
    public var nodeDescription: String? {
        return String(describing: self.self)
    }
}

// MARK: - IndexPathNode

/// base tree structure and position
public protocol IndexPathNode {
    associatedtype T: IndexPathNode
    var parent: T? { get }
    var childs: [T] { get }
    var indexPath: IndexPath { get }
}

extension IndexPathNode {
    
    /// node of deep, value >= 1
    public var currentDeep: Int {
        return indexPath.count
    }
    
    public var index: Int {
        let index = indexPath
        return index[index.count-1]
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

extension IndexPathNode where Self.T == Self {
    
    public func getRootNode() -> Self {
        let seq = sequence(first: self) { $0.parent }
        return seq.first(where: { $0.parent == nil })!
    }
    
    /// get allsubnodes by recurrence way
    ///
    /// - Parameter includeSelf: the allsubnodes include self or not
    /// - Returns: array of all subnodes
    public func allSubnodes(_ includeSelf: Bool = true) -> [Self] {
//        let seq = sequence(first: includeSelf ? [self] : self.childs) { $0.map({ $0.childs }).flatMap({ $0 }) }
//        return seq.flatMap({ $0 })
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
    
    /// the deepest of node tree
    /// note: minimum deep start from 1
    public var treeDeep: Int {
        return getRootNode().allSubnodes().max { $0.currentDeep < $1.currentDeep }?.currentDeep ?? 1
    }
}

// MARK: - VerticalTreeNode

/// Node protocol
public protocol VerticalTreeNode: IndexPathNode where Self.T == Self {
    
    /// indexViewLegnth
    var length: TreeNodeLength { get }
    
    /// info description
    var info: Infomation { get }
    
    var isFold: Bool { set get }
}
