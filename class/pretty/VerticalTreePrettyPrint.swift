//
//  VerticalTreePrettyPrint.swift
//  Pods-Demo
//
//  Created by Daniel Yang on 2019/4/15.
//

import UIKit

//MARK: - helper

fileprivate var verticalTreeTitle: String {
    return "\n======>> Vertical Tree <<======\n\n"
}

extension UIResponder {
    // get vc by the responder chain
    fileprivate var parentVC: UIViewController? {
        return sequence(first: self.next) { $0?.next }.first { $0 is UIViewController } as? UIViewController
    }
}

//MARK: - VerticalTreeSolution
private class VerticalTreeSolution<Obj: NSObject & IndexPathNode> where Obj.T == Obj {
    /// baseTree‘s structure
    static func treePrettyText(obj: Obj, inDebug: Bool = false) -> String {
        return NodeWrapper(obj: obj).subTreePrettyText(moreInfoIfHave: inDebug, highlighted: nil)
    }
    
    /// get ofTop‘s structure & highlight position of self
    static func treePrettyText(obj: Obj, ofTop: Obj, inDebug: Bool = false) {
        let parentChain = sequence(first: obj) { $0.parent }
        if !parentChain.contains(ofTop) {
            print("ofTop:\"\(String(describing: type(of: ofTop)))\" is invalid, not a node on top current:\"\(String(describing: type(of: self)))\"")
            return
        }
        let rootNode = NodeWrapper(obj: ofTop)
        let rootSubnodes = rootNode.allSubnodes()
        let selfNode = rootSubnodes.first { $0.obj == obj }!
        let selfSubnodes = selfNode.allSubnodes()
        
        let rootString = rootSubnodes.map { $0.nodePrettyText(inDebug) + "\n" }.joined()
        let selfString = selfSubnodes.map { $0.nodePrettyText(inDebug) + "\n" }.joined()
        
        let nodeFirstLength = selfSubnodes.first!.nodePrettyText(inDebug).count
        let nodeLastLength = selfSubnodes.last!.nodePrettyText(inDebug).count
        let separateChain = sequence(first: "= ") { _ in "= " }
        let prefix = separateChain.prefix(nodeFirstLength/2).joined()
        let sufix = separateChain.prefix(nodeLastLength/2).joined()
        
        let newSelfString = "\(prefix)\n\(selfString)\(sufix)\n"
        let result = rootString.replacingOccurrences(of: selfString, with: newSelfString)
        print(verticalTreeTitle + result)
    }
    
    // get the baseTree of rootNode
    static func getTreeRoot(_ obj: Obj) -> Obj {
        return obj.getRootNode()
    }
    
    static func indexPath(_ obj: Obj) -> IndexPath {
        let seq = sequence(first: obj) { $0.parent }.reversed()
        let indexs = seq.map { $0.parent?.childs.firstIndex(of: $0) ?? 0 }
        return IndexPath(indexes: indexs)
    }
}

//MARK: - Pretty Print
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
        return verticalTreeTitle + self.allSubnodes().map { $0.nodePrettyText(moreInfoIfHave) + "\n" }.joined()
    }
    
    /// found rootNode then get the full tree
    public func treePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        return getRootNode().subTreePrettyText(moreInfoIfHave: moreInfoIfHave)
    }
}

extension CALayer: IndexPathNode {
    
    // helper
    private var treeBaseClass: CALayer { return self }
    // BaseTree
    public var parent: CALayer? { return superlayer }
    public var childs: [CALayer] { return sublayers ?? [] }
    // extension
    public func treePrettyPrint(inDebug: Bool = false) {
        print(self.treePrettyText(inDebug: inDebug))
    }
    public func treePrettyText(inDebug: Bool = false) -> String {
        return VerticalTreeSolution.treePrettyText(obj: treeBaseClass, inDebug: inDebug)
    }
    public func treePrettyText(ofTop: CALayer, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyText(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var getTreeRoot: CALayer {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
    public var indexPath: IndexPath {
        return VerticalTreeSolution.indexPath(treeBaseClass)
    }
}

extension UIView: IndexPathNode {
    // helper
    private var treeBaseClass: UIView { return self }
    // BaseTree
    public var parent: UIView? { return superview }
    public var childs: [UIView] { return subviews }

    // extension
    public func treePrettyPrint(inDebug: Bool = false) {
        print(self.treePrettyText(inDebug: inDebug))
    }
    public func treePrettyText(inDebug: Bool = false) -> String {
        return VerticalTreeSolution.treePrettyText(obj: treeBaseClass, inDebug: inDebug)
    }
    public func treePrettyText(ofTop: UIView, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyText(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var getTreeRoot: UIView {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
    public var indexPath: IndexPath {
        return VerticalTreeSolution.indexPath(treeBaseClass)
    }
}

extension UIViewController: IndexPathNode {
    // helper
    private var treeBaseClass: UIViewController { return self }
    // BaseTree
    public var parent: UIViewController? { return self.parentVC }
    public var childs: [UIViewController] { return children }
    // extension
    public func treePrettyPrint(inDebug: Bool = false) {
        print(self.treePrettyText(inDebug: inDebug))
    }
    public func treePrettyText(inDebug: Bool = false) -> String {
        return VerticalTreeSolution.treePrettyText(obj: treeBaseClass, inDebug: inDebug)
    }
    public func treePrettyText(ofTop: UIViewController, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyText(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var getTreeRoot: UIViewController {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
    public var indexPath: IndexPath {
        return VerticalTreeSolution.indexPath(treeBaseClass)
    }
}
