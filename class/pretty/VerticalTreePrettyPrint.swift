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
    fileprivate var parentVC: UIViewController? {
        let seq = sequence(first: self.next) { $0?.next }
        return seq.first { $0 is UIViewController } as? UIViewController
    }
}

//MARK: - Pretty Print
extension TreeNode {
    
    private var verticalTreeTitle: String {
        return "\n======>> Vertical Tree <<======\n\n"
    }
    
    public func nodePrettyPrintString(_ moreInfoIfHave: Bool = false) -> String {
        let nodeChain = sequence(first: parent) { $0?.parent }
        let preSpace = nodeChain.map { ($0?.parent?.haveNext ?? false) ? " |" : "" }.joined()
        let firstPre = (haveParent ? " |" : "") + "——— "
        let keyText = moreInfoIfHave ? (info.nodeDescription ?? info.nodeTitle) : info.nodeTitle
        return preSpace + firstPre + keyText
    }
    
    public func currentTreePrettyPrintString(_ moreInfoIfHave: Bool = false) -> String {
        return verticalTreeTitle
            + self.allSubnodes().map { $0.nodePrettyPrintString(moreInfoIfHave) + "\n" }.joined()
    }
    
    public func allTreePrettyPrintString(_ moreInfoIfHave: Bool = false) -> String {
        return getRootNode().currentTreePrettyPrintString(moreInfoIfHave)
    }
}

extension CALayer: BaseTree {
    public var parent: CALayer? {
        return superlayer
    }
    public var childs: [CALayer] {
        return sublayers ?? []
    }
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
    public var toVC: UIViewController {
        return self
    }
}

extension BaseTree where Self: NSObject, Self == Self.T {
    @discardableResult public func prettyPrint(_ inDebug: Bool = false) -> String {
        return NodeWrapper(obj: self).currentTreePrettyPrintString(inDebug).printIt()
    }
    public var getRoot: Self {
        let seq = sequence(first: self) { $0.parent }
        return seq.first { $0.parent == nil }!
    }
}
