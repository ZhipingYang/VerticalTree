<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/56595379-1abc1b00-6621-11e9-912a-b80db0f3792c.png">
</p>


> Provides a vertical drawing of the tree structure which can view information about the tree‘s nodes and supports console debug views & layers and so on

### 安装

使用 Podfile，要求 `iOS >= 9.0`

```ruby
pod 'VerticalTree'

#或者只需要核心功能
pod 'VerticalTree/Core'

#只需要 PrettyText log
pod 'VerticalTree/PrettyText'
```

#### 代码结构

```
─┬─ "VerticalTree"
 ├─┬─ "Core" 核心功能
 │ ├─── VerticalTreeNodeProtocol
 │ └─── VerticalTreeNodeWrapper
 ├─┬─ "UI" 绘制图形树（可折叠）
 │ ├─── VerticalTreeCell
 │ ├─── VerticalTreeIndexView
 │ ├─── VerticalTreeListController
 │ └─── VerticalTreeListView
 └─┬─ "PrettyText" 终端文本树
   └─── VerticalTreePrettyPrint
```

#### 主要协议

```swift
/// base treeNode structure and position
public protocol IndexPathNode {
    associatedtype T: IndexPathNode
    var parent: T? { get }
    var childs: [T] { get }
    var indexPath: IndexPath { get }
}

/// Node protocol
public protocol VerticalTreeNode: IndexPathNode where Self.T == Self {
    
    /// indexViewLegnth
    var length: TreeNodeLength { get }
    
    /// info description
    var info: Infomation { get }
    
    var isFold: Bool { set get }
}
```

#### UIView 示范

> `UIView` 的层级就是树状结构
> 
> - 图形树绘制 (可折叠)
> - 文本树生成

<p align="center">
<img width=30% src="https://user-images.githubusercontent.com/9360037/56594927-48ed2b00-6620-11e9-980e-3bcfef3556a8.jpg"> <img width=30% src="https://user-images.githubusercontent.com/9360037/56594688-dc722c00-661f-11e9-83f0-3990d13f0947.jpg">
<img width=36.5% src="https://user-images.githubusercontent.com/9360037/56591555-8bf8cf80-661b-11e9-93f8-f2bb374415eb.png">
</p>

## 用法
### 1. 图形树
> 以UIView示范: 如图

![vertical_tree](https://user-images.githubusercontent.com/9360037/56594078-d891da00-661e-11e9-8403-25178464905e.gif)

```swift
// in ViewController
let treeVC = VerticalTreeListController(source: NodeWrapper(obj: view))
// then show the treeVC
```
> **Tip:** <br>
> NodeWrapper对泛型`obj`是弱引用，obj或其某个子节点被释放后，Node会保留着基础信息，但是TreeNode.Infomation.nodeDescription（折叠里的信息）是nil的，故当前node是无法张开查看


#### 自定义配置节点属性

使用如下 NodeWrapper 的方法

```swift
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
```

如图：修改 UIViewController 的 Wrapper

<img width=500 src="https://user-images.githubusercontent.com/9360037/56355927-1c917300-620a-11e9-9281-6658245cd321.jpg">

```swift
// default to change all subnode in the same rules unless inChild set false
let wrapper = NodeWrapper(obj: keyWindow.rootController).changeProperties {
    $0.isFold = false	// 默认全部Node展开
    $0.nodeDescription = "more infomation that you see now"
}
```

### 2. 文本树 - 如图

![tree](https://user-images.githubusercontent.com/9360037/56596664-8a330a00-6623-11e9-8e0d-58c2ef7cb9bb.jpg)


> 以UIView示范，让 UIView 遵守协议；
> 更多详见Demo（UIView，CALayer，UIViewController，自定义Node）

```swift
extension UIView: IndexPathNode {
    public var parent: UIView? {
        return superview
    }
    public var childs: [UIView] {
        return subviews
    }
}
```
然后 Wrapper 包装成 Node节点

```swift
// in ViewController
let rootNode = NodeWrapper(obj: view)
// 打印node结构
print(rootNode.subTreePrettyText())
```

使用 [VerticalTree/PrettyText](https://github.com/ZhipingYang/VerticalTree/blob/master/class/pretty/VerticalTreePrettyPrint.swift#L85) 的UIView扩展更简单

```swift
extension IndexPathNode where Self: NSObject, Self == Self.T {
    /// print
    public func treePrettyPrint(inDebug: Bool = false) {...}
    /// baseTree‘s structure
    public func treePrettyText(inDebug: Bool = false) -> String {...}
    /// get ofTop‘s structure & highlight position of self
    public func treePrettyText(ofTop: Self, inDebug: Bool = false) { ... }
    // get the baseTree of rootNode
    public var getTreeRoot: Self { ... }
}
```
- 打印当前View树结构

> `view.treePrettyPrint()`

- 打印当前Windows树结构

> `view.getTreeRoot.treePrettyPrint()` 

- 打印当前View树结构(查看更多debug信息)

> `view.treePrettyPrint(true)`

![image](https://user-images.githubusercontent.com/9360037/56597052-47256680-6624-11e9-90ed-e78181eba479.png)

### 顺便提一下

- LLDB 调试 view & layer & controller 的层级
    -  view & layer
        - 方法1 `po yourObj.value(forKey: "recursiveDescription")!`
        - 方法2 `expression -l objc -O -- [`yourObj` recursiveDescription]`
    - controller
        - 方法1 `po yourController.value(forKey: "_printHierarchy")!`
        - 方法2 `expression -l objc -O -- [`yourController` _printHierarchy]`

![image](https://user-images.githubusercontent.com/9360037/56284463-16868e00-6147-11e9-834e-306c10c0926d.png)

## Author

XcodeYang, xcodeyang@gmail.com

## License

VerticalTree is available under the MIT license. See the LICENSE file for more info.

