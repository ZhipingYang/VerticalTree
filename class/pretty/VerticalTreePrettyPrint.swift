//
//  VerticalTreePrettyPrint.swift
//  Pods-Demo
//
//  Created by Daniel Yang on 2019/4/15.
//

import UIKit

//MARK: - helper
extension UIResponder {
    // get vc by the responder chain
    fileprivate var parentVC: UIViewController? {
        return sequence(first: self.next) { $0?.next }.first { $0 is UIViewController } as? UIViewController
    }
}

//MARK: - VerticalTreeSolution
private class VerticalTreeSolution<Obj: NSObject & BaseNode> where Obj.T == Obj {
    /// baseTree‘s structure
    static func treePrettyText(obj: Obj, inDebug: Bool = false) -> String {
        return NodeWrapper(obj: obj).subTreePrettyText(moreInfoIfHave: inDebug, highlighted: nil)
    }
    
    /// get ofTop‘s structure & highlight position of self
    static func treePrettyPrint(obj: Obj, ofTop: Obj, inDebug: Bool = false) {
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
        print(VerticalTreeHeaderTitle + result)
    }
    
    // get the baseTree of rootNode
    static func getTreeRoot(_ obj: Obj) -> Obj {
        let seq = sequence(first: obj) { $0.parent }
        return seq.first(where: { $0.parent == nil })!
    }
}

extension CALayer: BaseNode {
    
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
    public func treePrettyPrint(ofTop: CALayer, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyPrint(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var rootNode: CALayer {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
}

extension UIView: BaseNode {
    
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
    public func treePrettyPrint(ofTop: UIView, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyPrint(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var rootNode: UIView {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
}

extension UIViewController: BaseNode {
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
    public func treePrettyPrint(ofTop: UIViewController, inDebug: Bool = false) {
        VerticalTreeSolution.treePrettyPrint(obj: treeBaseClass, ofTop: ofTop, inDebug: inDebug)
    }
    public var rootNode: UIViewController {
        return VerticalTreeSolution.getTreeRoot(treeBaseClass)
    }
}
