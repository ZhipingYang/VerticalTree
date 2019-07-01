//
//  DemoTests.swift
//  DemoTests
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
@testable import Demo
import VerticalTree

class DemoTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func customNodeTest() {
        
        // custome node
        XCTContext.runActivity(named: "custome node") { _ in
            let node = CustomNode()
            let subNode1 = CustomNode().then {
                $0.indexPath = node.indexPath.appending(0)
                node.childs.append($0)
            }
            let subNode2 = CustomNode().then {
                $0.indexPath = node.indexPath.appending(1)
                node.childs.append($0)
            }
            test(root: node, subnode1: subNode1, subnode2: subNode2)
        }
        
        // extension
        XCTContext.runActivity(named: "view node") { _ in
            let wrapperV = NodeWrapper(obj: UIView().then { root in
                UIView().do { root.addSubview($0) }
                UIView().do { root.addSubview($0) }
            })
            test(wrapper: wrapperV)
        }
        
        XCTContext.runActivity(named: "layer node") { _ in
            let wrapperL = NodeWrapper(obj: CALayer().then { root in
                CALayer().do { root.addSublayer($0) }
                CALayer().do { root.addSublayer($0) }
            })
            test(wrapper: wrapperL)
        }
        
        XCTContext.runActivity(named: "controllre node") { _ in
            let wrapperVC = NodeWrapper(obj: UIViewController().then { root in
                UIViewController().do { root.addChild($0) }
                UIViewController().do { root.addChild($0) }
            })
            test(wrapper: wrapperVC)
        }
    }
    
    func test<Obj: NSObject & BaseNode>(wrapper: NodeWrapper<Obj>) where Obj.T == Obj {
        test(root: wrapper, subnode1: wrapper.childs.first!, subnode2: wrapper.childs.last!)
    }
    
    func test<T: VerticalTreeNode>(root: T, subnode1: T, subnode2: T) {
        XCTAssert(root.haveChild == true)
        XCTAssert(root.haveParent == false)
        
        XCTAssert(root.childs.first?.indexPath == subnode1.indexPath)
        XCTAssert(root.childs.last?.indexPath == subnode2.indexPath)
        XCTAssert(root.allSubnodes().count == 3, "root\(root) have child \(root.allSubnodes()) is error")
        XCTAssert(root.allSubnodes(false).count == 2)
        XCTAssert(root.currentDeep == 1)
        XCTAssert(root.index == 0)
        XCTAssert(root.treeDeep == 2)
        
        XCTAssert(subnode1.parent?.indexPath == root.indexPath)
        XCTAssert(subnode1.rootNode.indexPath == root.indexPath)
        XCTAssert(subnode1.currentDeep == 2)
        XCTAssert(subnode1.haveNext == true)
        
        XCTAssert(subnode2.parent?.indexPath == root.indexPath)
        XCTAssert(subnode2.index == 1)
        XCTAssert(subnode2.currentDeep == 2)
        XCTAssert(subnode2.haveNext == false)
    }
}
