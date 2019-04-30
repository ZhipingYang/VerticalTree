//
//  IndexTreeProtocol.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/21.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

/// index width
///
/// - eachWidth: eachWidth of the next node
/// - IndexWidth: whole width of indexView
public enum TreeNodeLength {
    case eachLength(_ length: CGFloat)
    case indexLength(_ length: CGFloat)
}

/// show the node info
public protocol Infomation {
    var nodeTitle: String { get }
    var nodeDescription: String? { get }
}

/// base treeNode structure and position
public protocol IndexPathNode {
    associatedtype T: IndexPathNode
    var parent: T? { get }
    var childs: [T] { get }
    var indexPath: IndexPath { get }
}

/// Node protocol
public protocol VerticalTreeNode: IndexPathNode where Self.T == Self {
    /// indexViewLegnth
    var length: TreeNodeLength { get }
    /// info description
    var info: Infomation { get }
    var isFold: Bool { set get }
}
