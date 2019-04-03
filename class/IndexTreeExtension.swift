//
//  IndexTreeExtension.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import ObjectiveC


private var TreeNodeDeepConst = 0

extension UIView: TreeNode {
    
    var parent: TreeNode? {
        return self.superview
    }
    
    var childs: [TreeNode] {
        return self.subviews
    }
    
    var currentDeep: Int {
        let sequ = sequence(first: self) { $0.superview }
        return sequ.reduce(0, { (deep, view) -> Int in
            return deep+1
        })
    }
    
    // todo: name space
    var treeDeep: Int {
        return rootView.allSubnodes().map { $0.currentDeep }.max() ?? 1
//        set {
//            objc_setAssociatedObject(self.rootView, &TreeNodeDeepConst, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//        get {
//            guard let number = objc_getAssociatedObject(self.rootView, &TreeNodeDeepConst) as? NSNumber else { return 1 }
//            return number.intValue
//        }
    }
    
    var length: TreeNodeLength {
        return .eachLength(10)
    }

    var info: Infomation {
        return self
    }
    
    var index: Int {
        return superview?.subviews.firstIndex(of: self) ?? 0
    }

}

extension UIView {
    
    var rootView: UIView {
        return self.getRootNode()
    }
    
    var allSubviews: [UIView] {
        return self.allSubnodes()
    }
}
