## Vertical Tree

> Provides a vertical drawing of the tree structure which can view information about the tree‘s nodes and supports console debug views & layers and so on

#### 安装

Podfile 添加

```ruby
pod 'VerticalTree'
#或者只需要核心功能
pod 'VerticalTree/Core'
#只需要PrettyText
pod 'VerticalTree/PrettyText'
```

临时方案 😂

`pod 'VerticalTree', :git => 'https://github.com/ZhipingYang/VerticalTree.git'`

#### 代码结构

```
——— "VerticalTree"
 |——— "Core" 核心功能
 | |——— VerticalTreeNodeProtocol
 | |——— VerticalTreeNodeWrapper
 |——— "UI" 绘制图形树（可折叠）
 | |——— VerticalTreeCell
 | |——— VerticalTreeIndexView
 | |——— VerticalTreeListController
 | |——— VerticalTreeListView
 |——— "PrettyText" 终端文本树
 | |——— VerticalTreePrettyPrint
```

#### 主要协议

```swift
public protocol BaseTree {
    associatedtype T: BaseTree
    var parent: T? {get}
    var childs: [T] {get}
}

/// Node protocol
public protocol TreeNode: BaseTree {
    associatedtype U: TreeNode where Self.U == Self
    var parent: U? {get}
    var childs: [U] {get}

    /// note: deep start from 1
    var currentDeep: Int {get}

    /// note: minimum deep start from 1
    var treeDeep: Int {get}
    var index: Int {get}

    /// indexViewLegnth
    var length: TreeNodeLength {get}

    /// info description
    var info: Infomation {get}
    var isFold: Bool {set get}    
}

```

#### UIView 示范

> `UIView` 的层级就是树状结构
> - 图形树绘制 (可折叠)
> - 文本树生成

<p align="center">
<img width=30% src="https://user-images.githubusercontent.com/9360037/56127886-c07fe200-5fb0-11e9-9c8a-ce677ea0b7e5.PNG"> <img width=30% src="https://user-images.githubusercontent.com/9360037/56130707-3e93b700-5fb8-11e9-914b-08abd4335eb0.PNG">
<img width=36% src="https://user-images.githubusercontent.com/9360037/56188383-f330e580-6057-11e9-94f7-b74bed4ebd23.png">
</p>

#### 用法
> 以UIView示范，让 UIView 遵守协议；
> 更多详见Demo（UIView，CALayer，UIViewController，自定义Node）

```swift
extension UIView: BaseTree {
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
extension BaseTree where Self: NSObject, Self == Self.T {
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

> `view.treePrettyPrint()` 输入文本树如上：UIView示范

- 打印当前Windows树结构

> `view.getTreeRoot.treePrettyPrint()` 

- 打印当前View树结构(查看更多debug信息)

> `view.treePrettyPrint(true)`![image](https://user-images.githubusercontent.com/9360037/56188507-46a33380-6058-11e9-8f98-37646a2cbfe0.png)

### 顺便提一下

- LLDB 调试 view & layer & controller 的层级
    -  view & layer
        - `po yourObj.value(forKey: "recursiveDescription")!`
        - `expression -l objc -O -- [`yourObj` recursiveDescription]`
    - controller
        - `po yourController.value(forKey: "_printHierarchy")!`
        - `expression -l objc -O -- [`yourController` _printHierarchy]`

![image](https://user-images.githubusercontent.com/9360037/56284463-16868e00-6147-11e9-834e-306c10c0926d.png)

## Author

XcodeYang, xcodeyang@gmail.com

## License

VerticalTree is available under the MIT license. See the LICENSE file for more info.

