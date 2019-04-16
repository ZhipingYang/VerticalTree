//
//  VerticalTreePrettyPrint.swift
//  Pods-Demo
//
//  Created by Daniel Yang on 2019/4/15.
//

import UIKit

//MARK: - helper
extension String {
    fileprivate func printIt() -> String {
        print(self)
        return self
    }
}
extension UIResponder {
    // get vc by the responder chain
    fileprivate var parentVC: UIViewController? {
        return sequence(first: self.next) { $0?.next }.first { $0 is UIViewController } as? UIViewController
    }
}

//MARK: - Pretty Print
extension TreeNode {
    
    private var verticalTreeTitle: String {
        return "\n======>> Vertical Tree <<======\n\n"
    }
    
    /// get treeNode pretty description
    public func nodePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        let nodeChain = sequence(first: parent) { $0?.parent }
        let spaceStrings = nodeChain.map { ($0 != nil) ? ($0?.haveNext ?? false ? " |" : ($0?.haveParent ?? false ? "  ":"")) : "" }
        let firstPre = (haveParent ? " |" : "") + "——— "
        let keyText = moreInfoIfHave ? (info.nodeDescription ?? info.nodeTitle) : info.nodeTitle
        return spaceStrings.reversed().joined() + firstPre + keyText
    }
    
    /// as a subtree at current node
    public func subTreePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        return verticalTreeTitle + self.allSubnodes().map { $0.nodePrettyText(moreInfoIfHave) + "\n" }.joined()
    }
    
    /// found rootNode then get the full tree
    public func treePrettyText(_ moreInfoIfHave: Bool = false) -> String {
        return getRootNode().subTreePrettyText(moreInfoIfHave)
    }
}

extension CALayer: BaseTree {
    public var parent: CALayer? {
        return superlayer
    }
    public var childs: [CALayer] {
        return sublayers ?? []
    }
    // helper
    public var toLayer: CALayer {
        return self
    }
}

extension UIView: BaseTree {
    public var parent: UIView? {
        return superview
    }
    public var childs: [UIView] {
        return subviews
    }
    // helper
    public var toView: UIView {
        return self
    }
}

extension UIViewController: BaseTree {
    public var parent: UIViewController? {
        return self.parentVC
    }
    public var childs: [UIViewController] {
        return children
    }
    // helper
    public var toVC: UIViewController {
        return self
    }
}

extension BaseTree where Self: NSObject, Self == Self.T {
    
    /// print baseTree‘s structure
    @discardableResult
    public func treePrettyPrint(_ inDebug: Bool = false) -> String {
        return NodeWrapper(obj: self).subTreePrettyText(inDebug).printIt()
    }
    
    // get the baseTree of rootNode
    public var getTreeRoot: Self {
        let seq = sequence(first: self) { $0.parent }
        return seq.first { $0.parent == nil }!
    }
}
