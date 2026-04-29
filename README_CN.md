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

VerticalTree 用来把树状结构数据渲染成纵向、可折叠的 UIKit 列表，也提供适合控制台输出的树形文本格式化能力。它既可以展示自定义数据结构，也可以检查 UIView、CALayer、UIViewController 等 UIKit 层级。

## 环境要求

- Xcode 26.2
- Swift 6 language mode
- iOS 26.2+
- CocoaPods

## 安装

安装默认包，包含 Core、UI、PrettyExtension：

```ruby
pod 'VerticalTree'
```

只安装数据模型和文本树核心能力：

```ruby
pod 'VerticalTree/Core'
```

安装 UIView、CALayer、UIViewController 的文本树扩展：

```ruby
pod 'VerticalTree/PrettyExtension'
```

## Demo

旧的 Xcode Demo 工程已经移除，现在改为源码化 Demo，通过 XcodeGen 和 CocoaPods 按需生成。

```sh
./GenerateDemo.command
```

该命令会根据 `Demo/project.yml` 重新生成 `Demo/VerticalTreeDemo.xcworkspace`，执行 `pod install`，并打开 workspace。`Demo/Pods`、`Demo/*.xcodeproj`、`Demo/*.xcworkspace`、`Demo/Podfile.lock` 等生成产物会被 Git 忽略。

Demo 包含：

- 自定义树状结构数据
- 固定可复现的 sample forest
- UIView、UIWindow、CALayer 层级检查
- 控制台 pretty print 示例

## 截图

### UIKit 层级

<p align="center">
    <img width="30%" alt="UIView 层级树" src="https://user-images.githubusercontent.com/9360037/56594927-48ed2b00-6620-11e9-980e-3bcfef3556a8.jpg">
    <img width="30%" alt="可折叠纵向树" src="https://user-images.githubusercontent.com/9360037/56594688-dc722c00-661f-11e9-83f0-3990d13f0947.jpg">
    <img width="36%" alt="控制台树输出" src="https://user-images.githubusercontent.com/9360037/56591555-8bf8cf80-661b-11e9-93f8-f2bb374415eb.png">
</p>

### 折叠与查看

<p align="center">
    <img width="72%" alt="VerticalTree 展开折叠演示" src="https://user-images.githubusercontent.com/9360037/56594078-d891da00-661e-11e9-8403-25178464905e.gif">
</p>

### 控制台输出

<p align="center">
    <img width="78%" alt="文本树输出" src="https://user-images.githubusercontent.com/9360037/56596664-8a330a00-6623-11e9-8e0d-58c2ef7cb9bb.jpg">
</p>

<p align="center">
    <img width="78%" alt="带 debug 信息的文本树输出" src="https://user-images.githubusercontent.com/9360037/56597052-47256680-6624-11e9-90ed-e78181eba479.png">
</p>

### 节点配置

<p align="center">
    <img width="70%" alt="NodeWrapper 属性配置" src="https://user-images.githubusercontent.com/9360037/56355927-1c917300-620a-11e9-9281-6658245cd321.jpg">
</p>

### LLDB 参考

<p align="center">
    <img width="76%" alt="LLDB 层级调试输出" src="https://user-images.githubusercontent.com/9360037/56284463-16868e00-6147-11e9-834e-306c10c0926d.png">
</p>

## 模块结构

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

## 核心协议

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

`Infomation` 会继续保留，用来兼容旧代码。新代码如果只是引用协议类型，可以使用拼写正确的 `Information` 别名。

## 自定义数据

自定义模型实现 `VerticalTreeNode` 即可。引用类型建议把 `parent` 声明为 `weak`，避免树节点互相强持有。

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

展示一个或多个根节点：

```swift
let controller = VerticalTreeListController<DemoTreeNode>(style: .plain)
controller.title = "Sample Forest"
controller.rootNodes = DemoTreeNode.sampleForest()
navigationController?.pushViewController(controller, animated: true)
```

如果要自己处理点击事件，而不是使用内置展开/折叠：

```swift
controller.didSelectHandler = { node in
    print(node.info.nodeTitle)
}
```

`didSelectedHandle` 仍然保留为废弃兼容别名，新代码请使用 `didSelectHandler`。

## UIKit 树

`NodeWrapper` 可以包装任意满足 `NSObject & BaseNode` 且节点类型指向自身的对象。PrettyExtension 已经内置了 UIView、CALayer、UIViewController 的树形扩展。

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

`NodeWrapper` 对被包装对象是弱引用。原始对象释放后，wrapper 仍保留基础树结构，但依赖对象实时生成的 debug 描述可能不可用。

## 控制台文本树

```swift
print(view.treePrettyText(inDebug: true))
view.treePrettyPrint()
view.rootNode.treePrettyPrint(inDebug: true)
```

也可以打印自定义 `VerticalTreeNode`：

```swift
print(rootNode.subTreePrettyText(moreInfoIfHave: true))
```

## UIKit 与 Swift 6 说明

`UIView` 和 `UIViewController` 通过 `@MainActor` 隔离的 conformance 实现 `BaseNode`，访问 UI 树相关 API 时请在主线程/主 actor 中进行。

列表节点的长按复制菜单已使用 `UIEditMenuInteraction`，不再依赖废弃的 `UIMenuController` API。

## 作者

XcodeYang, xcodeyang@gmail.com

## License

VerticalTree is available under the MIT license. See the LICENSE file for more info.
