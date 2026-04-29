<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/56595379-1abc1b00-6621-11e9-912a-b80db0f3792c.png">
</p>

<p align="center">
    <a href="http://cocoapods.org/pods/VerticalTree">
        <image alt="Version" src="https://img.shields.io/cocoapods/v/VerticalTree.svg?style=flat">
    </a>
    <image alt="Swift" src="https://img.shields.io/badge/Swift-6-orange.svg">
    <image alt="iOS" src="https://img.shields.io/badge/iOS-26.2%2B-blue.svg">
    <a href="http://cocoapods.org/pods/VerticalTree">
        <image alt="License" src="https://img.shields.io/cocoapods/l/VerticalTree.svg?style=flat">
    </a>
    <a href="http://cocoapods.org/pods/VerticalTree">
        <image alt="Platform" src="https://img.shields.io/cocoapods/p/VerticalTree.svg?style=flat">
    </a>
</p>

VerticalTree renders tree-structured data as a vertical, foldable UIKit list. It also provides console-friendly tree formatting for custom models, views, layers, and view controllers.

## Requirements

- Xcode 26.2
- Swift 6 language mode
- iOS 26.2+
- CocoaPods

## Installation

Install the default package, which includes Core, UI, and PrettyExtension:

```ruby
pod 'VerticalTree'
```

Install only the data model and pretty-printing core:

```ruby
pod 'VerticalTree/Core'
```

Install the UIKit/CALayer/UIViewController pretty-print extensions:

```ruby
pod 'VerticalTree/PrettyExtension'
```

## Demo

The old checked-in Xcode demo has been replaced by a source-only demo generated on demand with XcodeGen and CocoaPods.

```sh
./GenerateDemo.command
```

The command rebuilds `Demo/VerticalTreeDemo.xcworkspace` from `Demo/project.yml`, runs `pod install`, and opens the workspace. Generated files such as `Demo/Pods`, `Demo/*.xcodeproj`, `Demo/*.xcworkspace`, and `Demo/Podfile.lock` are intentionally ignored by Git.

The demo includes:

- custom structured data trees
- a deterministic sample forest
- UIView, UIWindow, and CALayer hierarchy inspection
- console pretty-print examples

## Screenshots

### UIKit Hierarchy

<p align="center">
    <img width="30%" alt="UIView hierarchy tree" src="https://user-images.githubusercontent.com/9360037/56594927-48ed2b00-6620-11e9-980e-3bcfef3556a8.jpg">
    <img width="30%" alt="Foldable vertical tree" src="https://user-images.githubusercontent.com/9360037/56594688-dc722c00-661f-11e9-83f0-3990d13f0947.jpg">
    <img width="36%" alt="Console tree output" src="https://user-images.githubusercontent.com/9360037/56591555-8bf8cf80-661b-11e9-93f8-f2bb374415eb.png">
</p>

### Fold And Inspect

<p align="center">
    <img width="72%" alt="VerticalTree fold and unfold demo" src="https://user-images.githubusercontent.com/9360037/56594078-d891da00-661e-11e9-8403-25178464905e.gif">
</p>

### Console Output

<p align="center">
    <img width="78%" alt="Pretty printed tree" src="https://user-images.githubusercontent.com/9360037/56596664-8a330a00-6623-11e9-8e0d-58c2ef7cb9bb.jpg">
</p>

<p align="center">
    <img width="78%" alt="Pretty printed tree with debug information" src="https://user-images.githubusercontent.com/9360037/56597052-47256680-6624-11e9-90ed-e78181eba479.png">
</p>

### Node Configuration

<p align="center">
    <img width="70%" alt="NodeWrapper property configuration" src="https://user-images.githubusercontent.com/9360037/56355927-1c917300-620a-11e9-9281-6658245cd321.jpg">
</p>

### LLDB Reference

<p align="center">
    <img width="76%" alt="LLDB hierarchy debug output" src="https://user-images.githubusercontent.com/9360037/56284463-16868e00-6147-11e9-834e-306c10c0926d.png">
</p>

## Modules

```text
VerticalTree
├── Core
│   ├── VerticalTreeProtocol
│   ├── VerticalTreeProtocolExtension
│   └── VerticalTreeNodeWrapper
├── UI
│   ├── VerticalTreeCell
│   ├── VerticalTreeIndexView
│   └── VerticalTreeListController
└── PrettyExtension
    └── VerticalTreePrettyPrint
```

## Core Protocols

```swift
public protocol Infomation {
    var nodeTitle: String { get }
    var nodeDescription: String? { get }
}

public typealias Information = Infomation

public protocol BaseNode {
    associatedtype T: BaseNode
    var parent: T? { get }
    var childs: [T] { get }
}

public protocol IndexPathNode: BaseNode {
    var indexPath: IndexPath { get }
}

public protocol VerticalTreeNode: IndexPathNode where Self.T == Self {
    var length: TreeNodeLength { get }
    var info: Infomation { get }
    var isFold: Bool { get set }
}
```

`Infomation` is kept for source compatibility. New code can use the correctly spelled `Information` alias when referring to the same protocol type.

## Custom Data

Create a model that conforms to `VerticalTreeNode`. Keep `parent` weak for reference types to avoid retain cycles.

```swift
final class DemoTreeNode: NSObject, VerticalTreeNode {
    weak var parent: DemoTreeNode?
    var childs: [DemoTreeNode]
    var indexPath: IndexPath
    var length: TreeNodeLength = .index(180)
    var isFold = false

    var info: Information { self }
    var nodeTitle: String
    var nodeDescription: String?

    init(
        title: String,
        description: String? = nil,
        children: [DemoTreeNode] = []
    ) {
        self.nodeTitle = title
        self.nodeDescription = description
        self.childs = []
        self.indexPath = IndexPath(index: 0)
        super.init()
        setChildren(children)
    }

    private func setChildren(_ children: [DemoTreeNode]) {
        childs = children
        children.enumerated().forEach { offset, child in
            child.parent = self
            child.reindex(indexPath.appending(offset))
        }
    }

    private func reindex(_ path: IndexPath) {
        indexPath = path
        childs.enumerated().forEach { offset, child in
            child.parent = self
            child.reindex(path.appending(offset))
        }
    }
}
```

Display one or more root nodes:

```swift
let controller = VerticalTreeListController<DemoTreeNode>(style: .plain)
controller.title = "Sample Forest"
controller.rootNodes = DemoTreeNode.sampleForest()
navigationController?.pushViewController(controller, animated: true)
```

Handle selection yourself instead of using the built-in fold/unfold behavior:

```swift
controller.didSelectHandler = { node in
    print(node.info.nodeTitle)
}
```

`didSelectedHandle` is still available as a deprecated compatibility alias. Prefer `didSelectHandler` in new code.

## UIKit Trees

`NodeWrapper` can wrap any `NSObject & BaseNode` where the node type points back to itself. The PrettyExtension module already makes `UIView`, `CALayer`, and `UIViewController` usable as tree sources.

```swift
let wrapper = NodeWrapper(obj: view).changeProperties { node in
    node.length = .index(180)
    node.isFold = node.currentDeep > 2
    if let view = node.obj {
        node.nodeDescription = "\(type(of: view)) frame: \(view.frame)"
    }
}

let controller = VerticalTreeListController(source: wrapper)
controller.title = "Preview View"
navigationController?.pushViewController(controller, animated: true)
```

`NodeWrapper` keeps the wrapped object weakly. If the original object is released, the wrapper still keeps basic node structure, but object-derived debug text may become unavailable.

## Console Pretty Print

```swift
print(view.treePrettyText(inDebug: true))
view.treePrettyPrint()
view.rootNode.treePrettyPrint(inDebug: true)
```

You can also print a custom `VerticalTreeNode`:

```swift
print(rootNode.subTreePrettyText(moreInfoIfHave: true))
```

## UIKit And Swift 6 Notes

`UIView` and `UIViewController` conform to `BaseNode` through `@MainActor` isolated conformances. Access UI tree APIs from the main actor.

The list cell copy menu uses `UIEditMenuInteraction`, replacing the deprecated `UIMenuController` APIs.

## Author

XcodeYang, xcodeyang@gmail.com

## License

VerticalTree is available under the MIT license. See the LICENSE file for more info.
