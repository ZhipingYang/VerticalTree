<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/56595379-1abc1b00-6621-11e9-912a-b80db0f3792c.png">
</p>

<p align="center">
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="Version" src="https://img.shields.io/cocoapods/v/VerticalTree.svg?style=flat">
	</a>
	<image alt="CI Status" src="https://img.shields.io/badge/Swift-5.0-orange.svg">
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="License" src="https://img.shields.io/cocoapods/l/VerticalTree.svg?style=flat">
	</a>
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="Platform" src="https://img.shields.io/cocoapods/p/VerticalTree.svg?style=flat">
	</a>
	<a href="https://travis-ci.org/ZhipingYang/VerticalTree">
		<image alt="CI Status" src="http://img.shields.io/travis/ZhipingYang/VerticalTree.svg?style=flat">
	</a>
</p>

> Provides a vertical drawing of the tree structure which can view information about the tree‘s nodes and supports console debug views & layers and so on

### Install

required `iOS >= 9.0` `Swift5.0` with [Cocoapods](https://cocoapods.org/)

```ruby
pod 'VerticalTree'
```

only install core functions

```ruby
pod 'VerticalTree/Core'
```
install prettyPrint extension for view、layer、viewController

```ruby
pod 'VerticalTree/PrettyExtension'
```

#### file structures

```
─┬─ "VerticalTree"
 ├─┬─ "Core": basic functions
 │ ├─── VerticalTreeProtocol
 │ ├─── VerticalTreeProtocolExtension
 │ └─── VerticalTreeNodeWrapper
 ├─┬─ "UI": draw a graph of VerticalTree which is foldable
 │ ├─── VerticalTreeCell
 │ ├─── VerticalTreeIndexView
 │ └─── VerticalTreeListController
 └─┬─ "PrettyExtension": pretty print in xcode console
   └─── VerticalTreePrettyPrint
```

#### core protocols

```swift
/// base node
public protocol BaseNode {
    associatedtype T: BaseNode
    var parent: T? { get }
    var childs: [T] { get }
}

/// base treeNode structure and position
public protocol IndexPathNode: BaseNode {
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

### Example for UIView

> `UIView` is a tree structure
> 
> - VerticalTree in tableview
> - VerticalTree in console log

<p align="center">
<img width=30% src="https://user-images.githubusercontent.com/9360037/56594927-48ed2b00-6620-11e9-980e-3bcfef3556a8.jpg"> <img width=30% src="https://user-images.githubusercontent.com/9360037/56594688-dc722c00-661f-11e9-83f0-3990d13f0947.jpg">
<img width=36.5% src="https://user-images.githubusercontent.com/9360037/56591555-8bf8cf80-661b-11e9-93f8-f2bb374415eb.png">
</p>

## Using
### 1. draw the VerticalTree in tableview
> for example a UITableViewCell structure:

![vertical_tree](https://user-images.githubusercontent.com/9360037/56594078-d891da00-661e-11e9-8403-25178464905e.gif)

```swift
// in ViewController
let treeVC = VerticalTreeListController(source: NodeWrapper(obj: view))
// then show the treeVC
```

#### Config Node's info

in NodeWrapper's method

```swift
/// config current node’s property value and recurrence apply the same rule in childNodes if you want
///
/// - Parameters:
///   - inChild: recurrence config in child or just config current
///   - config: rules
/// - Returns: self
@discardableResult
public func changeProperties(inChild: Bool = true, config: (NodeWrapper<Obj>) -> Void) -> Self {}
```

follow picture: modify UIViewController's Wrapper

<img width=500 src="https://user-images.githubusercontent.com/9360037/56355927-1c917300-620a-11e9-9281-6658245cd321.jpg">

```swift
// default to change all subnode in the same rules unless inChild set false
let wrapper = NodeWrapper(obj: keyWindow.rootController).changeProperties {
    $0.isFold = false	// all node set unfold in default 
    $0.nodeDescription = "more infomation that you see now"
}
```

### 2. Text VerticalTree - in Console log

![tree](https://user-images.githubusercontent.com/9360037/56596664-8a330a00-6623-11e9-8e0d-58c2ef7cb9bb.jpg)


> UIView as the example to follow the IndexPathNode protocol <br>
> see more others extension like CALayer，UIViewController in the demo

```swift
extension UIView: BaseNode {
    public var parent: UIView? {
        return superview
    }
    public var childs: [UIView] {
        return subviews
    }
}
```
get a wrapper of the view as a root node

```swift
// in ViewController
let rootNode = NodeWrapper(obj: view)
// print node structure in text
print(rootNode.subTreePrettyText())
```

Using UIView's Extension as an easier way, check here [VerticalTree/PrettyText](https://github.com/ZhipingYang/VerticalTree/blob/master/class/pretty/VerticalTreePrettyPrint.swift#L19)

```swift
extension BaseNode where Self: NSObject, Self == Self.T {
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
- print current view as root node

> `view.treePrettyPrint()`

- print view's Window structure

> `view.rootNode.treePrettyPrint()` 

- show more infomation

> `view.treePrettyPrint(inDebug: true)`

![image](https://user-images.githubusercontent.com/9360037/56597052-47256680-6624-11e9-90ed-e78181eba479.png)

### BTW

- LLDB debug view & layer & controller's hierarchy
    -  view & layer
        - method-1: `po yourObj.value(forKey: "recursiveDescription")!`
        - method-2: `expression -l objc -O -- [`yourObj` recursiveDescription]`
    - controller
        - method-1: `po yourController.value(forKey: "_printHierarchy")!`
        - method-2: `expression -l objc -O -- [`yourController` _printHierarchy]`

![image](https://user-images.githubusercontent.com/9360037/56284463-16868e00-6147-11e9-834e-306c10c0926d.png)

## Author

XcodeYang, xcodeyang@gmail.com

## License

VerticalTree is available under the MIT license. See the LICENSE file for more info.

