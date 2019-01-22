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

extension UIView {
    var rootNode: UIView {
        return GetRootNode(self)
    }
    var allSubnodes: [UIView] {
        return AllSubnodes(self)
    }
}

extension UIView: TreeNode {
    
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
            objc_setAssociatedObject(self.rootNode, &TreeNodeDeepConst, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let number = objc_getAssociatedObject(self.rootNode, &TreeNodeDeepConst) as? NSNumber else { return 1 }
            return number.intValue
        }
    }
    
    var length: TreeNodeLength {
        return .eachLength(10)
    }

    var source: Infomation {
        return self
    }
}
