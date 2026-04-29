//
//  VerticalTreeProtocolExtension.swift
//  Pods-Demo
//
//  Created by Daniel Yang on 2019/4/30.
//

import Foundation

// MARK: - Infomation of NSObject
extension Infomation where Self: NSObjectProtocol {
    public var nodeTitle: String {
        return String(describing: type(of: self))
    }
    public var nodeDescription: String? {
        return String(describing: self.self)
    }
}

// MARK: - BaseNode
extension BaseNode {

    public var haveChild: Bool {
        return self.childs.count > 0
    }

    public var children: [T] {
        return childs
    }

    public var haveParent: Bool {
        return self.parent != nil
    }
}

extension BaseNode where Self.T == Self {

    public var rootNode: T {
        let seq = sequence(first: self) { $0.parent }
        return seq.first(where: { $0.parent == nil })!
    }

    /// get allsubnodes by recurrence way
    ///
    /// - Parameter includeSelf: the allsubnodes include self or not
    /// - Returns: array of all subnodes
    public func allSubnodes(_ includeSelf: Bool = true) -> [T] {
        var nodes = [T]()

        func append(_ node: T, includeSelf: Bool) {
            if includeSelf { nodes.append(node) }
            node.childs.forEach { append($0, includeSelf: true) }
        }

        append(self, includeSelf: includeSelf)
        return nodes
    }
}

// MARK: - IndexPathNode
extension IndexPathNode {

    /// node of deep, value >= 1
    public var currentDeep: Int {
        return max(indexPath.count, 1)
    }

    public var index: Int {
        return indexPath.last ?? 0
    }

    public var haveNext: Bool {
        return self.index < (self.parent?.childs.count ?? 1) - 1
    }
}

extension IndexPathNode where Self.T == Self {

    /// the deepest of node tree
    /// note: minimum deep start from 1
    public var treeDeep: Int {
        func maxDeep(_ node: T) -> Int {
            return node.childs.reduce(node.currentDeep) { max($0, maxDeep($1)) }
        }

        return maxDeep(rootNode)
    }
}

// MARK: - VerticalTreeNode

var VerticalTreeHeaderTitle: String {
    return "\n======>> Vertical Tree <<======\n\n"
}

// Pretty Print
extension VerticalTreeNode {
    /// Box-drawing character https://en.wikipedia.org/wiki/Box-drawing_character
    /// get treeNode pretty description
    public func nodePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        let nodeChain = sequence(first: parent) { $0?.parent }
        let spaceStrings = nodeChain.map { ($0 != nil) ? ($0?.haveNext ?? false ? " │" : ($0?.haveParent ?? false ? "  ":"")) : "" }
        let firstPre = (haveParent ? (haveNext ? " ├" : " └") : "") + (haveChild ? "─┬─ ":"─── ")
        let keyText = moreInfoIfHave ? (info.nodeDescription ?? info.nodeTitle) : info.nodeTitle
        return spaceStrings.reversed().joined() + firstPre + keyText
    }

    /// as a subtree at current node
    public func subTreePrettyText(moreInfoIfHave: Bool = false, highlighted: Self? = nil) -> String {
        return VerticalTreeHeaderTitle + self.allSubnodes().map { $0.nodePrettyText(moreInfoIfHave) + "\n" }.joined()
    }

    /// found rootNode then get the full tree
    public func treePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        return rootNode.subTreePrettyText(moreInfoIfHave: moreInfoIfHave)
    }
}
