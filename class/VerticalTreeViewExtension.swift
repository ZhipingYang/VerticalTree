//
//  IndexTreeExtension.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import ObjectiveC

private struct UIViewTreeAssociateKey {
    static var isFold = 0
}

extension UIView: Infomation {
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

final class ViewTreeNode: TreeNode, Infomation {
    
    typealias NodeValue = ViewTreeNode
    
    weak var view: UIView?
    var parent: ViewTreeNode?
    var childs: [ViewTreeNode]
    var isFold: Bool {
        get {
            return view?.isFold ?? true
        }
        set {
            view?.isFold = newValue
        }
    }
    var index: Int
    var length: TreeNodeLength
    var info: Infomation { return self }
    var nodeTitle: String
    var nodeDescription: String? {
        return view?.nodeDescription
    }

    convenience init(view: UIView) {
        self.init(view)!
    }
    
    required init?(_ view: UIView?) {
        guard let view = view else { return nil }
        self.view = view
        self.childs = view.subviews.compactMap{ ViewTreeNode($0) }
        self.index = view.superview?.subviews.firstIndex(of: view) ?? 0
        self.length = .indexLength(80)
        self.nodeTitle = view.nodeTitle
        
        self.childs.forEach { $0.parent = self }
    }
}
