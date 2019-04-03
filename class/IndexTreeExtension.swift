//
//  IndexTreeExtension.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

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
}

extension UIColor {
    static let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.black]
    static func int(_ num: Int) -> UIColor {
        return colors[num%(colors.count)]
    }
}
