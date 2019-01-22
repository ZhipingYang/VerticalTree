//
//  IndexTreeView.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/18.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeView<T: TreeNode>: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var horizonLine: CALayer = {
        let horizonLine = CALayer()
        horizonLine.backgroundColor = UIColor.gray.cgColor
        return horizonLine
    }()
    
    var verticalLines = [CALayer]()
    
    var node: T? = nil {
        didSet {
            guard let node = node else { return }
            label.text = node.source.title
            
            verticalLines.forEach{ $0.removeFromSuperlayer() }
            verticalLines.removeAll()
            verticalLines = (0...node.currentDeep).map { _ -> CALayer in
                let layer = CALayer()
                layer.backgroundColor = UIColor.gray.cgColor
                return layer
            }
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        guard let node = node else { return }
        let width =  self.frame.width
        let height =  self.frame.height
        var eachW: CGFloat = 0;
        if case .eachLength(let lengthValue) = node.length {
            eachW = lengthValue
        } else if case .indexLength(let lengthValue) = node.length {
            eachW = lengthValue / CGFloat(max(node.treeDeep, 1))
        }
        
        horizonLine.frame = CGRect(x: eachW * CGFloat(node.currentDeep-1),
                                   y: height/2.0,
                                   width: min(2*eachW, width-(eachW * CGFloat(node.currentDeep-1))),
                                   height: 1)
        var parent = node.parent
        while parent != nil {
            guard let p = parent else { break }
            verticalLines[p.currentDeep-1].frame = CGRect(x: eachW*CGFloat(p.currentDeep-1), y: 0, width: 1, height: height)
            verticalLines[p.currentDeep-1].isHidden = p.parent == nil
            parent = p.parent as? T.NodeValue
        }
    }
}
