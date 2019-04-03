//
//  IndexTreeView.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/18.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeView: UIView {
    
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
    
    var node: TreeNode? = nil {
        didSet {
            guard let node = node else { return }
            label.text = node.info.title
            
            verticalLines.forEach{ $0.removeFromSuperlayer() }
            verticalLines.removeAll()
            verticalLines = (0...node.currentDeep).map { _ in
                let layer = CALayer()
                layer.backgroundColor = UIColor.gray.cgColor
                return layer
            }
            verticalLines.forEach {
                layer.addSublayer($0)
            }
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        addSubview(label)
        layer.addSublayer(horizonLine)
        let longG = UILongPressGestureRecognizer(target: self, action: #selector(longPressToShowCopyMenu(_:)))
        addGestureRecognizer(longG)
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
//        horizonLine.backgroundColor = UIColor.int(node.currentDeep-1).cgColor
        horizonLine.backgroundColor = UIColor.gray.cgColor
        horizonLine.frame = CGRect(x: eachW * CGFloat(node.currentDeep-1),
                                   y: height/2.0,
                                   width: min(2*eachW, width-(eachW * CGFloat(node.currentDeep-1))),
                                   height: 1)
                
        let line1 = verticalLines[node.currentDeep-1]
        line1.isHidden = false
        line1.frame = CGRect(x: eachW * CGFloat(node.currentDeep-1), y: 0, width: 1, height: node.haveNext ? height : height*0.5);
        let line2 = verticalLines[node.currentDeep]
        line2.isHidden = false
        line2.frame = CGRect(x: eachW * CGFloat(node.currentDeep), y: height/2.0, width: 1, height: node.haveChild ? height/2.0 : 0);

        var parent = node.parent
        while parent != nil {
            guard let p = parent else { break }
            verticalLines[p.currentDeep-1].frame = CGRect(x: eachW*CGFloat(p.currentDeep-1), y: 0, width: 1, height: height)
            verticalLines[p.currentDeep-1].isHidden = !p.haveNext
            parent = p.parent
        }
        let right = horizonLine.frame.width + horizonLine.frame.origin.x
        label.frame = CGRect(x: right, y: 0, width: width-right, height: height)
    }
}

extension IndexTreeView {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText(_:))
            || action == #selector(showMoreInfo(_:))
            || action == #selector(showDebugInfo(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    @objc private func longPressToShowCopyMenu(_ sender: UILongPressGestureRecognizer) {
        let menu = UIMenuController.shared
        if sender.state != .began, menu.isMenuVisible { return }
        becomeFirstResponder()
        menu.menuItems = [UIMenuItem(title: "Copy", action: #selector(copyText(_:)))]
        menu.setTargetRect(bounds, in: self)
        menu.setMenuVisible(true, animated: true)
    }
    
    @objc private func copyText(_ sender: Any?) {
        UIPasteboard.general.string = label.text
    }
    
    @objc private func showMoreInfo(_ sender: Any?) {
        
    }
    
    @objc private func showDebugInfo(_ sender: Any?) {
        
    }
}
