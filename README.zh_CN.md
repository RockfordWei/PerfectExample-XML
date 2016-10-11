# Perfect XML 函数库使用范例 [English](README.md)


<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="https://gitter.im/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_2_Git.jpg" alt="Chat on Gitter" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="https://gitter.im/PerfectlySoft/Perfect?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge" target="_blank">
        <img src="https://img.shields.io/badge/Gitter-Join%20Chat-brightgreen.svg" alt="Join the chat at https://gitter.im/PerfectlySoft/Perfect">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>

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

## getElementsByTagName()方法的更多细节

实际上，.getElementsByTagName返回的是一个节点数组 [XElement]，如同数据库的一个结果记录集一样。

以下代码展示了如何将所有标签名相同的同级节点返回为一个数组：

```Swift
print("显示同名标签节点数组\n")

func showItems() {
		// 选择所有名为“item”的节点
		let feedItems = xDoc?.documentElement?.getElementsByTagName("item")

		// 检查该数组实际元素数量
		let itemsCount = feedItems?.count
		print("总共找到 \(itemsCount!) 个元素\n")

		// 遍历结果集内所有元素
		for item in feedItems!
		{
				let title = item.getElementsByTagName("title").first?.nodeValue
				let link = item.getElementsByTagName("link").first?.nodeValue
				let description = item.getElementsByTagName("description").first?.nodeValue
				print("标题：\(title!)\t链接：\(link!)\t说明： \(description!)\n")
		}
}

showItems()
```

## 通过节点之间的关系进行访问

PerfectXML 函数库提供一系列简便方法，用于根据当前 XML 节点信息访问所有相关节点：父节点、子节点和同级相邻节点：

### 父节点

父节点的访问可以通过当前节点的“parentNode”属性进行访问，用法如下：

```Swift
print("父节点\n")

func showParent(tag: String) {

		guard let node = xDoc?.documentElement?.getElementsByTagName(tag).first else {
			print("未找到标签名为“\(tag)”的节点。\n")
			return
		}

		// 访问父节点；如果父节点为空则意味着是根节点。
		guard let parent = node.parentNode else {
			print("标签“\(tag)”为文档根节点。\n")
			return
		}
		let name = parent.nodeName
		print("节点“\(tag)”的父节点（上一级节点）是“\(name)”。\n")
}

showParent(tag: "link")
```

### 同级相邻节点

每个 XML 节点都可能存在两个同级相邻节点：previousSibling（前一个节点）和 nextSibling（后一个节点）。以下代码演示了相邻节点的互相访问：

```Swift
print("同级相邻节点：\n")

func showSiblings (tag: String) {

		let node = xDoc?.documentElement?.getElementsByTagName(tag).first

		// 查看当前节点的前一个同级相邻节点。
		let previousNode = node?.previousSibling
		var name = previousNode?.nodeName
		var value = previousNode?.nodeValue
		print("标签“\(tag)”的前一个同级相邻节点名称为\(name!)，\t内容值为：\(value!)\n")

    // 查看当前节点的后一个同级相邻节点。
		let nextNode = node?.nextSibling
		name = nextNode?.nodeName
		value = nextNode?.nodeValue
    print("标签“\(tag)”的后一个同级相邻节点名称为\(name!)，\t内容值为：\(value!)\n")
}


showSiblings(tag: "link")
showSiblings(tag: "description")
```

### 子节点：首个子节点和末尾子节点

如果一个 XML 节点存在子节点，那么可以尝试用 .firstChild （首个子节点）/ .lastChild （末尾子节点）属属性直接访问，而避免通过.childNodes 子节点数组去计算和访问：

```Swift
print("首个子节点和末尾子节点\n")

func firstLast() {
		let node = xDoc?.documentElement?.getElementsByTagName("channel").first

		/// 返回首个子节点
		let firstChild = node?.firstChild
		var name = firstChild?.nodeName
		var value = firstChild?.nodeValue
		print("Channel的首个子节点是：\(name!)\t\(value!)\n")

		/// 返回末尾子节点
		let lastChild = node?.lastChild
		name = lastChild?.nodeName
		value = lastChild?.nodeValue
    print("Channel的末尾子节点是：\(name!)\t\(value!)\n")
}

firstLast()
```

上述方法在默写情况下使得编程过程更加简练，比如在网页间跳转并选择首页和尾页。

## 节点属性

任意 XML 节点/元素都能自定义多个属性，格式如下：

 ```XML
 <node attribute1='value of attribute1' attribute2='value of attribute2'>
   ...
 </node>
```

节点对象方法 .getAttribute(name: String) 用于访问这些属性。参考以下例子：

```Swift
print("打印节点属性\n")

func showAttributes() {
		let node = xDoc?.documentElement?.getElementsByTagName("title").first

		/// 读取一个节点的若干属性
		let att1 = node?.getAttribute(name: "attribute1")
		print("标题对象的属性1“attribute1”内容为 \(att1)\n")

		let att2 = node?.getAttributeNode(name: "attribute2")
    print("标题对象的属性2“attribute2”内容为 \(att2)\n")
}

showAttributes()
```

## 命名空间

XML 规定了允许在同一个 XML文档内保证名称属性即使重复也能实现唯一性访问的方法，即命名空间。一个 XML 实例可以包含不限于同一 XML 字典约束的任意元素或属性名称。如果每个字典都有一个独立的命名空间，则区分重名元素和重名属性变得非常简单，不会导致内容混淆。

访问节点及属性的方法 .getElementsByTagName() 和 .getAttributeNode() 都有命名空间的版本，即 .getElementsByTagNameNS() 和 .getAttributeNodeNS。这种情况下，同时需要输入命名空间名称 namespaceURI 和在该空间内的本地名称 localName 以完成查询 —— 就像姓和名一样确保提取过程的唯一性。

以下代码演示了 .getElementsByTagNameNS() 和 .getNamedItemNS()的使用方法：

```Swift
print("命名空间\n")

func showNamespaces(){
	let deeper = xDoc?.documentElement?.getElementsByTagName("deeper").first
	let atts = deeper?.firstChild?.attributes;
	let item = atts?.getNamedItemNS(namespaceURI: "foo:bar", localName: "atr2")
	print("deeper的命名空间内有一个属性值为“\(item?.nodeValue)”。\n")

	let foos = xDoc?.documentElement?.getElementsByTagNameNS(namespaceURI: "foo:bar", localName: "fool")
	var count = foos?.count
	let node = foos?.first
	let name = node?.nodeName
	let localName = node?.localName
	let prefix = node?.prefix
	let nuri = node?.namespaceURI

	print("“foo:bar”命名空间有以下\(count!) 个元素：\n")
	print("节点名称： \(name!)\n")
	print("本地名称： \(localName!)\n")
	print("前缀： \(prefix!)\n")
	print("命名空间唯一资源路径URI：\(nuri!)\n")

	let children = node?.childNodes

	count = children?.count

	let a = node?.firstChild
	let b = node?.lastChild

	let na = a?.nodeName
	let nb = b?.nodeName
	let va = a?.nodeValue
	let vb = b?.nodeValue

	print("该节点还包含 \(count!) 个子节点。\n")
	print("第一个子节点名称为“\(na!)”，内容值为“\(va!)”。\n")
  print("最后一个子节点名称为“\(nb!)”，内容值为“\(vb!)”。\n")
}

showNamespaces()

```

## XPath

XPath 的官方名称为 XML 路径语言，是用于在 XML文档中筛选节点的一种查询语言。此外，XPath 还可以用于在 XML 文档内用于计算变量值（比如字符串、数值或者逻辑布尔变量值）。

以下程序演示可以根据您自行输入的路径进行节点访问：

```Swift

print("XML 路径查询演示\n")

func showXPath(xpath: String) {
    /// 请使用.extract()方法来处理 XPath 请求信息：
		let pathResource = xDoc?.extract(path: xpath)
		print("XPath路径： '\(xpath)':\n\(pathResource!)\n")
}

showXPath(xpath: "/rss/channel/item")
showXPath(xpath: "/rss/channel/title/@attribute1")
showXPath(xpath: "/rss/channel/link/text()")
showXPath(xpath: "/rss/channel/item[2]/deeper/foo:bar")
```

完成后即可编译运行，并请尝试自行改变上述路径以检查实际效果。现在您可能已经理解为什么说 XML 和 XPath 功能如此强大 —— 理论上一个XML文件足可以将整个文件系统包裹起来，对不对？

### Swift 语言兼容性

本项目仅支持 Swift 3.0 toolchain 工具集，可随 Xcode 8.0 以上版本一同安装；或在 Linux 上通过官网 [Swift.org](http://swift.org/)下载安装。

## Swift 版本要求：

由于 Xcode 8 在发行后不久发现了一些问题，如果您仍然坚持使用 Xcode 开发本项目或类似项目，我们建议您自行安装 swiftenv，并安装最新的 Swift 3.0.1 预览版工具集：

```
# after installing swiftenv from https://swiftenv.fuller.li/en/latest/
swiftenv install https://swift.org/builds/swift-3.0.1-preview-1/xcode/swift-3.0.1-PREVIEW-1/swift-3.0.1-PREVIEW-1-osx.pkg
```

在 Xcode 中另外一种方法是在“项目设定”中将函数库搜索路径“Library Search Paths”递归追加到工程根目录 “$(PROJECT_DIR)”下。


## 问题报告、内容贡献和客户支持

我们目前正在过渡到使用JIRA来处理所有源代码资源合并申请、修复漏洞以及其它有关问题。因此，GitHub 的“issues”问题报告功能已经被禁用了。

如果您发现了问题，或者希望为改进本文提供意见和建议，[请在这里指出](http://jira.perfect.org:8080/servicedesk/customer/portal/1).

在您开始之前，请参阅[目前待解决的问题清单](http://jira.perfect.org:8080/projects/ISS/issues).

### Contributing

我们欢迎所有贡献以及对Perfect文档提高的宝贵意见。我们欢迎您为Perfect付出宝贵的支持。如果您发现了任何文字或者内容有错误，或者有任何建议，请[提交一个代码上传请求，或在JIRA上报告问题](http://jira.perfect.org:8080/servicedesk/customer/portal/1/user/login?destination=portal%2F1).

## 更多信息
更多信息请详见 Perfect 工程官网 [perfect.org](http://perfect.org).
