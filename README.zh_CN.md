# Perfect XML 函数库使用范例 [English](README.md)


Perfect XML 函数库的使用和演示

本文档用于演示如何操作XML函数库。*⚠️注意⚠️* 目前PerfectXML函数库只支持 DOM 二级核心 Core level 2，而且包括在XPath的功能支持上，都是只读的！

## 安装和设置

在开始编程之前，需要确定Swift 3.0已经安装成功。如有需要，请查看[Swift 3.0 安装指南（英文版）] (http://swift.org)。

### Linux 安装注意事项

如果您希望在 Ubuntu Linux 编译并测试本程序，请注意务必安装libxml：

```bash
sudo apt-get install libxml2-dev
```


## 快速上手

本项目的初衷是展示一下如何从一个XML字符串中读取期望的数据。换言之，如果把XML当作一个数据库，那么我们的PerfectXML就是数据库的连接接口，而XPath就是查询语言。您可以从github上下载我们的范本源代码用于快速上手：

```bash
git clone https://github.com/PerfectlySoft/PerfectExample-XML.git
```

或者您也可以从一个空目录开始逐步尝试：

```bash
mkdir PerfectExample-XML
cd PerfectExample-XML
swift package init
```

这种情况下，您需要手工编辑 Package.swift 并将 Perfect-libxml2 / Perfect-XML 库标记为引用：

```Swift
import PackageDescription

let package = Package(
	name: "PerfectExample-XML",
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-libxml2.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-XML.git", majorVersion: 2, minor: 0)
    ]
)
```

设置完成后就可以在您的 main.swift 文件中引用 PerfectXML函数库了：

```Swift
import PerfectXML
```

这时您就可以试一下编译和运行。请使用SPM命令进行编译：

```bash
swift build
./.build/debug/PerfectExample-XML
```

## XML样本文件

在进行任何实际读取操作之前，请将下面的XML样本字符串拷贝到您的程序中。您也可以自己找一个XML文件放在目录下，然后通过代码把内容读出来，效果也是一样的，目标都是要取得XML的字符串：

```Swift
let rssXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
"<rss version=\"2.0\">" +
"<channel>" +
"<title attribute1='第一个属性' attribute2='第二个属性'>W3学校标准主页</title>" +
"<link>http://www.w3schools.com</link>" +
"<description>Web开发免费教程</description>" +
"<item id='rssID'>" +
"<title>RSS 频道订阅教程</title>" +
"<link>http://www.w3schools.com/xml/xml_rss.asp</link>" +
"<description>新版RSS教程</description>" +
"</item>" +
"<item id='xmlID'>" +
"<title>XML 教程</title>" +
"<link>http://www.w3schools.com/xml</link>" +
"<description>新版XML教程</description>" +
"<deeper xmlns:foo='foo:bar'>" +
"<deepest foo:atr1='一个垃圾' foo:atr2='另一个垃圾'></deepest>" +
"<foo:fool><foo:silly>🍒樱桃卷饼</foo:silly><foo:dummy>饼卷樱桃🍒</foo:dummy></foo:fool>" +
"</deeper>" +
"</item>" +
"</channel>" +
"</rss>"
```

## 格式化XML

相信您对上面的字符串的第一印象就是——乱七八糟的——对吧？没关系。我们有一个很棒的功能就是把 XML 文档进行格式调整，整理为很漂亮的标准文本：

```Swift
let xDoc = XDocument(fromSource: rssXML)
let prettyString = xDoc?.string(pretty: true)
let plainString = xDoc?.string(pretty: false)
```

第一行 ``` xDoc = XDocument ``` 创建了一个 XML 对象，然后方法 ```string(pretty: Bool)``` 能够再把文本读回来，而且可以选择是否格式化。

想知道到底能把XML整容到什么程度？试试下面的代码：

```Swift
print("解析一个 XML 文档\n")

func showParse() {
		print("原始 XML文件：\n\(rssXML)\n\n")
		print("格式化后的效果：\n\(prettyString!)\n\n")
		print("未经加工的内容：\n\(plainString!)\n\n")
}

showParse()

```

如果运行成功，应该能够看到三个不同的XML结果输出。最上面的是原始的XML文件内容，最下面的解析但是未经格式化的内容，中间的是经过格式化处理的漂亮文本。

## XML 节点

XML是一个结构化文本，每个形如```<A>B</A>```的结构都是一个XML节点。每个节点都包含一个标签名(tag name)、内容值或子节点。为了更好的理解这个定义，我们试着用下面的程序来遍历整个XML文件：

首先，我们需要一个递归函数来实现遍历：

```Swift
func printChildrenName(_ xNode: XNode) {

	// 检查一下节点类型是不是文字节点
	guard let text = xNode as? XText else {

			// 如果不是就输出节点类型
			print("节点名称：\(xNode.nodeName)\t节点类型：\(xNode.nodeType)\t（包含子节点）\n")

			// 遍历每个子节点
			for n in xNode.childNodes {

				// 再次调用递归函数
				printChildrenName(n)
			}
			return
	}

	// 如果是文字节点就直接打印出来
	print("节点名称：\(xNode.nodeName)\t节点类型\(xNode.nodeType)\t内容值\t\(text.nodeValue!)\n")
}
```


然后将根节点作为参数直接调用这个递归函数就可以查看整个 XML 的信息：

```Swift
printChildrenName( xDoc!)
```

## 通过标签名称访问节点

访问节点的最基本方法就是通过节点名称实现。以下程序展示了```getElementsByTagName ```的通用方法：

```Swift
func testTag(tagName: String) {

	// 调用 .getElementsByTagName 访问节点
	// 并且检查该节点是否有效（在XML文件中存在）
		guard let node = xDoc?.documentElement?.getElementsByTagName(tagName) else {
			print("未找到标签“\(tagName)”\n")
			return
		}

		// 如果找到了，就提取首个节点作为代表
		guard let value = node.first?.nodeValue else {
			print("标签“\(tagName)”不包含内容。\n")
			return
		}

		// 显示节点内容
		print("节点“\(tagName)”内容为“\(value)”\n")
}

testTag(tagName: "link")
testTag(tagName: "description")
```

## 通过ID唯一属性标识符访问节点

另外一种便捷的方法是通过唯一标识符进行节点提取。您可能已经注意到有一些节点带有一个特殊的属性叫做“id”，包含这种属性的节点可以用另外一种方法进行访问：

```XML
<item id='xmlID'>
```

具体实现方法是使用 PerfectXML 函数库提供的.getElementById()方法，这样就能实现与前文类似但是又不一样的节点访问简便方法：

```Swift
func testID(id: String) {

		// 如果存在适合的ID，就可以用下面的方法进行访问
		guard let node = xDoc?.getElementById(id) else {
			print("文档中不存在这样的ID“\(id)”\n")
			return
		}

		guard let value = node.nodeValue else {
			print("id名为“\(id)”的节点没有内容\n")
			return
		}

		print("节点“\(id)”内容为“\(value)”\n")
}

testID(id: "rssID")
testID(id: "xmlID")
```

能看出来 .getElementById() 和 .getElementsByTagName() 的区别吗？您可以试一试如果同一个文档中存在多个ID重复的节点时会有什么结果。

## getElementsByTagName()

Method .getElementsByTagName returns an array of nodes, i.e., [XElement], just like a record set in a database query.

The following code demonstrates how to iterate all element in this arrray:

```Swift
print("Show Items\n")

func showItems() {
		// get all items with tag name of "item"
		let feedItems = xDoc?.documentElement?.getElementsByTagName("item")

		// checkout how many items indeed.
		let itemsCount = feedItems?.count
		print("There are totally \(itemsCount!) Items Found\n")

		// iterate all items in the result set
		for item in feedItems!
		{
				let title = item.getElementsByTagName("title").first?.nodeValue
				let link = item.getElementsByTagName("link").first?.nodeValue
				let description = item.getElementsByTagName("description").first?.nodeValue
				print("Title: \(title!)\tLink: \(link!)'\tDescription: \(description!)\n")
		}
}

showItems()
```

## Relationships of a Node Family

PerfectXML provides a convenient way to access all relationships of a specific XML node: Parent, Siblings & Children.

### Parent of a Node

Parent node can be accessed by a node property called "parentNode", see the following example to see the usage:

```Swift
print("Parent of a Node\n")

func showParent(tag: String) {

		guard let node = xDoc?.documentElement?.getElementsByTagName(tag).first else {
			print("There is no such a tag '\(tag)'.\n")
			return
		}

		// HERE is the way of accessing a parent node
		guard let parent = node.parentNode else {
			print("Tag '\(tag)' is the root node.\n")
			return
		}
		let name = parent.nodeName
		print("Parent of '\(tag)' is '\(name)'\n")
}

showParent(tag: "link")
```

### Node Siblings

Each XML node can have two siblings: previousSibling and nextSibling. Try the following snippet to test the availability of siblings.

```Swift
print("Siblings of a Node\n")

func showSiblings (tag: String) {

		let node = xDoc?.documentElement?.getElementsByTagName(tag).first

		// Check the previous sibling of current node
		let previousNode = node?.previousSibling
		var name = previousNode?.nodeName
		var value = previousNode?.nodeValue
		print("Previous Sibling of \(tag) is \(name!)\t\(value!)\n")

		// Check the next sibling of current node
		let nextNode = node?.nextSibling
		name = nextNode?.nodeName
		value = nextNode?.nodeValue
		print("Next Sibling of \(tag) is \(name!)\t\(value!)\n")
}


showSiblings(tag: "link")
showSiblings(tag: "description")
```

### First & Last Child

If an XML node has a child, then you can try properties of .firstChild / .lastChild instead of accessing them from the .childNodes array:

```Swift
print("First & Last Child\n")

func firstLast() {
		let node = xDoc?.documentElement?.getElementsByTagName("channel").first

		/// retrieve the first child
		let firstChild = node?.firstChild
		var name = firstChild?.nodeName
		var value = firstChild?.nodeValue
		print("First Child of Channel is \(name!)\t\(value!)\n")

		/// retrieve the last child
		let lastChild = node?.lastChild
		name = lastChild?.nodeName
		value = lastChild?.nodeValue
		print("Last Child of Channel is \(name!)\t\(value!)\n")
}

firstLast()
```

These methods are convenient in certain scenarios, such as jump to the first page or the last page in a book.

## Node Attributes

Any XML node / element can have attributes in such a style:

 ```XML
 <node attribute1='value of attribute1' attribute2='value of attribute2'>
   ...
 </node>
```

Node method .getAttribute(name: String) provides the functionality of accessing attributes. See the code below:

```Swift
print("Attributes of an element\n")

func showAttributes() {
		let node = xDoc?.documentElement?.getElementsByTagName("title").first

		/// get some attributes of a node
		let att1 = node?.getAttribute(name: "attribute1")
		print("attribute1 of title is \(att1)\n")

		let att2 = node?.getAttributeNode(name: "attribute2")
		print("attribute2 of title is \(att2?.value)\n")
}

showAttributes()
```

## Namespaces

XML namespaces are used for providing uniquely named elements and attributes in an XML document. An XML instance may contain element or attribute names from more than one XML vocabulary. If each vocabulary is given a namespace, the ambiguity between identically named elements or attributes can be resolved.

Both .getElementsByTagName() and .getAttributeNode() have namespace versions, i.e., .getElementsByTagNameNS() / .getAttributeNodeNS, etc. In these cases, namespaceURI and localName shall present to complete the request.

The following code demonstrates the usage of .getElementsByTagNameNS() and .getNamedItemNS():

```Swift
print("Namespaces\n")

func showNamespaces(){
	let deeper = xDoc?.documentElement?.getElementsByTagName("deeper").first
	let atts = deeper?.firstChild?.attributes;
	let item = atts?.getNamedItemNS(namespaceURI: "foo:bar", localName: "atr2")
	print("Namespace of deeper has an attribute of \(item?.nodeValue)\n")

	let foos = xDoc?.documentElement?.getElementsByTagNameNS(namespaceURI: "foo:bar", localName: "fool")
	var count = foos?.count
	let node = foos?.first
	let name = node?.nodeName
	let localName = node?.localName
	let prefix = node?.prefix
	let nuri = node?.namespaceURI

	print("Namespace of 'foo:bar' has \(count!) element:\n")
	print("Node Name: \(name!)\n")
	print("Local Name: \(localName!)\n")
	print("Prefix: \(prefix!)\n")
	print("Namespace URI: \(nuri!)\n")

	let children = node?.childNodes

	count = children?.count

	let a = node?.firstChild
	let b = node?.lastChild

	let na = a?.nodeName
	let nb = b?.nodeName
	let va = a?.nodeValue
	let vb = b?.nodeValue

	print("This node also has \(count!) children.\n")
	print("The first one is called '\(na!)' with value of '\(va!)'.\n")
	print("And the last one is called '\(nb!)' with value of '\(vb!)'\n")
}

showNamespaces()

```

## XPath

XPath (XML Path Language) is a query language for selecting nodes from an XML document. In addition, XPath may be used to compute values (e.g., strings, numbers, or Boolean values) from the content of an XML document.

This demo can extract the path you input:

```Swift

print("XML Path Demo\n")

func showXPath(xpath: String) {
    /// Use .extract() method to deal with the XPath request.
		let pathResource = xDoc?.extract(path: xpath)
		print("XPath '\(xpath)':\n\(pathResource!)\n")
}

showXPath(xpath: "/rss/channel/item")
showXPath(xpath: "/rss/channel/title/@attribute1")
showXPath(xpath: "/rss/channel/link/text()")
showXPath(xpath: "/rss/channel/item[2]/deeper/foo:bar")
```

Then build & run and try any possible XPath as need. Now you can see how powerful XML & XPath are - theoretically, it can even wrap up a total file system, can't it?

Have Fun!


###Compatibility with Swift

This project works only with the Swift 3.0 toolchain available with Xcode 8.0+ or on Linux via [Swift.org](http://swift.org/).

## Swift version note:

Due to a late-breaking bug in Xcode 8, if you wish to run directly within Xcode, we recommend installing swiftenv and installing the Swift 3.0.1 preview toolchain.

```
# after installing swiftenv from https://swiftenv.fuller.li/en/latest/
swiftenv install https://swift.org/builds/swift-3.0.1-preview-1/xcode/swift-3.0.1-PREVIEW-1/swift-3.0.1-PREVIEW-1-osx.pkg
```

Alternatively, add to the "Library Search Paths" in "Project Settings" $(PROJECT_DIR), recursive.


## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)



## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
