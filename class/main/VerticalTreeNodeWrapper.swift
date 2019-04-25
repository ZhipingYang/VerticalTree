//
//  IndexTreeExtension.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

extension NSObject: Infomation {}

public final class NodeWrapper<Obj: NSObject & IndexPathNode>: VerticalTreeNode, Infomation where Obj.T == Obj {
    
    public typealias U = NodeWrapper<Obj>
    public var parent: U? = nil
    public var childs: [U]
    public var indexPath: IndexPath // do not modify
    public var length: TreeNodeLength = .indexLength(80)
    public var isFold: Bool = true
    public var info: Infomation { return self }
    public var nodeTitle: String
    public var nodeDescription: String? {
        set { _nodeDescription = newValue }
        get { return _nodeDescription ?? obj?.nodeDescription }
    }
    public weak var obj: Obj?
    
    private var _nodeDescription: String?

    public convenience init(obj: Obj, _ indexPath: IndexPath = IndexPath(index: 0)) {
        self.init(obj, indexPath)!
    }
    
    public required init?(_ obj: Obj?, _ indexPath: IndexPath? = nil) {
        guard let obj = obj else { return nil }
        let indexPath = indexPath ?? IndexPath(index: 0)
        
        self.obj = obj
        self.nodeTitle = obj.nodeTitle
        self.indexPath = indexPath
        self.childs = obj.childs.enumerated().map { NodeWrapper(obj: $0.element, indexPath.appending($0.offset)) }
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
