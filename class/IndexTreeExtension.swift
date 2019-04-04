//
//  IndexTreeExtension.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import ObjectiveC

private struct UIViewTreeAssociateKey {
    static var isFold = 0
    static var treeNodeObj = 0
}

extension UIView: Infomation {
    
    fileprivate var treeNode: ViewTreeNode {
        get {
            guard let node = objc_getAssociatedObject(self, &UIViewTreeAssociateKey.treeNodeObj) as? ViewTreeNode else {
                self.treeNode = ViewTreeNode(view: self)
                return self.treeNode
            }
            return node
        }
        set {
            objc_setAssociatedObject(self, &UIViewTreeAssociateKey.treeNodeObj, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var isFold: Bool {
        get {
            guard let number = objc_getAssociatedObject(self, &UIViewTreeAssociateKey.isFold) as? NSNumber else {
                self.isFold = true
                return self.isFold
            }
            return number.boolValue
        }
        set {
            objc_setAssociatedObject(self, &UIViewTreeAssociateKey.isFold, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

final class ViewTreeNode: TreeNode {
    typealias NodeValue = ViewTreeNode
    
    weak var view: UIView?
    var parent: ViewTreeNode?
    var childs: [ViewTreeNode]
    var isFold: Bool
    var index: Int
    var length: TreeNodeLength
    var info: Infomation {
        return view ?? self
    }
    
    convenience init(view: UIView) {
        self.init(view)!
    }
    
    required init?(_ view: UIView?) {
        guard let view = view else { return nil }
        self.view = view
        self.childs = view.subviews.compactMap{ ViewTreeNode($0) }
        self.isFold = view.isFold
        self.index = view.superview?.subviews.firstIndex(of: view) ?? 0
        self.length = .eachLength(10)
        self.childs.forEach { $0.parent = self }
    }
}

extension ViewTreeNode: Infomation {
    
    var title: String {
        return view?.title ?? ""
    }
    
    var description: String {
        return view?.description ?? ""
    }
}
