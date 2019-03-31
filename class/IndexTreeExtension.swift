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
    typealias NodeValue = UIView
    
    var parent: UIView? {
        return self.superview
    }
    
    var childs: [UIView] {
        return self.subviews
    }
    
    var currentDeep: Int {
        let sequ = sequence(first: self) { $0.superview }
        return sequ.reduce(1, { (deep, view) -> Int in
            return deep+1
        })
    }
    
    // todo: name space
    var treeDeep: Int {
        set {
            objc_setAssociatedObject(self.rootView, &TreeNodeDeepConst, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let number = objc_getAssociatedObject(self.rootView, &TreeNodeDeepConst) as? NSNumber else { return 1 }
            return number.intValue
        }
    }
    
    var length: TreeNodeLength {
        return .eachLength(10)
    }

    var info: Infomation {
        return self
    }
}

extension UIView {
    var rootView: UIView {
        return getRootNode(self)
    }
    var allSubviews: [UIView] {
        return allSubnodes(self)
    }
}
