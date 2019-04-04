//
//  IndexTreeView.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/18.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeView: UIView {
    
    var labelLeading: NSLayoutConstraint?
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
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
            
            verticalLines.getNewArray(needSpace: node.currentDeep+1, map: { () -> CALayer in
                let layer = CALayer()
                layer.backgroundColor = UIColor.gray.cgColor
                self.layer.addSublayer(layer)
                return layer
            }) { $0.removeFromSuperlayer() }
            labelLeading?.constant = indexWidth
            label.updateConstraintsIfNeeded()
            self.setNeedsLayout()
        }
    }
    
    var indexWidth: CGFloat {
        guard let node = node else { return -40 }
        let width =  self.frame.width
        var eachW: CGFloat = 0;
        if case .eachLength(let lengthValue) = node.length {
            eachW = lengthValue
        } else if case .indexLength(let lengthValue) = node.length {
            eachW = lengthValue / CGFloat(max(node.treeDeep, 1))
        }
        return eachW * CGFloat(node.currentDeep-1) + min(2*eachW, width-(eachW * CGFloat(node.currentDeep-1)))
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
        
        let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100)
        labelLeading = leading
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            leading,
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
        
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
    }
}

extension IndexTreeView {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText(_:)) {
            return true
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    @objc private func longPressToShowCopyMenu(_ sender: UILongPressGestureRecognizer) {
        let menu = UIMenuController.shared
        if sender.state != .began, menu.isMenuVisible { return }
        menu.menuItems = [UIMenuItem(title: "copy", action: #selector(copyText(_:)))]
        menu.setTargetRect(label.bounds, in: self.label)
        menu.setMenuVisible(true, animated: true)
        becomeFirstResponder()
    }
    
    @objc private func copyText(_ sender: Any?) {
        UIPasteboard.general.string = node?.info.description ?? node?.info.title
    }
}

extension Array {
    mutating func getNewArray(needSpace: Int, map: () -> Element, handle: ((Element) -> Void)?) -> Void {
        if needSpace > count {
            let new = (0 ..< needSpace-count).map { _ in map() }
            self.append(contentsOf: new)
        } else if needSpace < count {
            let removeArr = self.prefix(count-needSpace)
            removeArr.forEach { handle?($0) }
            self.removeSubrange(0..<(count-needSpace))
        }
    }
}
