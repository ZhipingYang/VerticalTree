## Vertical Tree

> Provides a vertical drawing of the tree structure and view information about the tree‘s nodes

#### 安装

Podfile 添加

```ruby
pod 'VerticalTree'
#或者只需要核心功能
pod 'VerticalTree/Core'
#只需要PrettyText
pod 'VerticalTree/PrettyText'
```

#### 代码结构

```
——— VerticalTree
|——— Core 核心功能
| |——— VerticalTreeNodeProtocol
| |——— VerticalTreeNodeWrapper
|——— UI 绘制图形树（可折叠）
| |——— VerticalTreeCell
| |——— VerticalTreeIndexView
| |——— VerticalTreeListController
| |——— VerticalTreeListView
|——— PrettyText 终端文本树
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
<img width=38% src="https://user-images.githubusercontent.com/9360037/56126323-8234f380-5fad-11e9-9d2b-ed08856cd1e3.png">
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
print(rootNode.currentTreePrettyPrintString())
```

使用 `VerticalTree/PrettyText`的UIView扩展更简单

```swift
extension BaseTree where Self: NSObject, Self == Self.T {
    // debug 可以查看更多信息
    @discardableResult public func prettyPrint(_ inDebug: Bool = false) -> String {
        return NodeWrapper(obj: self).currentTreePrettyPrintString().printIt()
    }
    public var getRoot: Self {
        let chain = sequence(first: self) { $0.parent }
        return chain.first { $0.parent == nil }!
    }
}
```
- 打印当前View树结构

> `view.prettyPrint()` 输入文本树如上：UIView示范

- 打印当前Windows树结构

> `view.getRoot.prettyPrint()` 

- 打印当前View树结构(查看更多debug信息)

> `view.prettyPrint(true)`![image](https://user-images.githubusercontent.com/9360037/56130480-97168480-5fb7-11e9-932f-f127454845e3.png)

## Author

XcodeYang, xcodeyang@gmail.com

## License

XYDebugView is available under the MIT license. See the LICENSE file for more info.

