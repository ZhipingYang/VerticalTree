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
}

extension UIView: TreeNode, Infomation {
    
    var parent: TreeNode? {
        return self.superview
    }
    
    var childs: [TreeNode] {
        return self.subviews
    }
    
    var length: TreeNodeLength {
        return .eachLength(8)
    }

    var info: Infomation {
        return self
    }
    
    var index: Int {
        return superview?.subviews.firstIndex(of: self) ?? 0
    }
    
    var isFold: Bool {
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
