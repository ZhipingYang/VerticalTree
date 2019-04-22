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

extension NSObject: Infomation {
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

public final class NodeWrapper<Obj: NSObject & BaseTree>: TreeNode, Infomation where Obj.T == Obj {
    
    public typealias U = NodeWrapper<Obj>
    public var parent: U?
    public var childs: [U]
    public var index: Int
    public var length: TreeNodeLength = .indexLength(80)
    public var isFold: Bool
    public var info: Infomation { return self }
    public var nodeTitle: String
    public var nodeDescription: String? {
        set { _nodeDescription = newValue }
        get { return _nodeDescription ?? obj?.nodeDescription }
    }
    public weak var obj: Obj?
    private var _nodeDescription: String?

    public convenience init(obj: Obj) {
        self.init(obj)!
    }
    
    public required init?(_ obj: Obj?) {
        guard let obj = obj else { return nil }
        self.obj = obj
        self.isFold = obj.isFold
        self.childs = obj.childs.map{ NodeWrapper(obj: $0) }
        self.index = obj.parent?.childs.firstIndex{ $0 == obj } ?? 0
        self.nodeTitle = obj.nodeTitle
        self.childs.forEach { $0.parent = self }
    }
    
    /// config current node’s property value and recurrence apply the same rule in childNodes if you want
    ///
    /// - Parameters:
    ///   - inChild: recurrence config in child or just config current
    ///   - config: rules
    /// - Returns: self
    @discardableResult
    public func changeProperties(inChild: Bool = true, config: (NodeWrapper<Obj>) -> Void) -> Self {
        config(self)
        if inChild { childs.forEach { $0.changeProperties(inChild: inChild, config: config) } }
        return self
    }
}
