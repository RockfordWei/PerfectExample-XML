//
//  main.swift
//  PerfectExample-XML
//
//  Created by Rockford Wei on 10/06/16.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectXML

let rssXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
"<rss version=\"2.0\">" +
"<channel>" +
"<title attribute1='first attribute' attribute2='second attribute'>W3Schools Home Page</title>" +
"<link>http://www.w3schools.com</link>" +
"<description>Free web building tutorials</description>" +
"<item id='rssID'>" +
"<title>RSS Tutorial</title>" +
"<link>http://www.w3schools.com/xml/xml_rss.asp</link>" +
"<description>New RSS tutorial on W3Schools</description>" +
"</item>" +
"<item id='xmlID'>" +
"<title>XML Tutorial</title>" +
"<link>http://www.w3schools.com/xml</link>" +
"<description>New XML tutorial on W3Schools</description>" +
"<deeper xmlns:foo='foo:bar'>" +
"<deepest foo:atr1='the value' foo:atr2='the other value'></deepest>" +
"<foo:fool><foo:silly>boo</foo:silly><foo:dummy>woo</foo:dummy></foo:fool>" +
"</deeper>" +
"</item>" +
"</channel>" +
"</rss>"

let xDoc = XDocument(fromSource: rssXML)
let prettyString = xDoc?.string(pretty: true)
let plainString = xDoc?.string(pretty: false)

print("=====================================================================\n")
print("Parse an XML document\n")

func showParse() {
		print("XML Parse Function\n")
		print("Orginal XML:\n\(rssXML)\n\n")
		print("Pretty:\n\(prettyString!)\n\n")
		print("Plain\n\(plainString!)\n\n")
}

showParse()


print("=====================================================================\n")
print("Walk Through\n")

func printChildrenName(_ xNode: XNode) {

	// try treating the current node as a text node
	guard let text = xNode as? XText else {

			// print out the node info
			print("Name:\t\(xNode.nodeName)\tType:\(xNode.nodeType)\t(children)\n")

			// find out children of the node
			for n in xNode.childNodes {

				// call the function recursively and take the same produces
				printChildrenName(n)
			}
			return
	}

	// it is a text node and print it out
	print("Name:\t\(xNode.nodeName)\tType:\(xNode.nodeType)\tValue:\t\(text.nodeValue!)\n")
}

func walkThrough() {
		print("Node Name, Type and Value\n")
		printChildrenName( xDoc!)
}

walkThrough()

print("=====================================================================\n")
print("Test Tag\n")

func testTag(tagName: String) {

	// use .getElementsByTagName to get this node.
	// check if there is such a tag in the xml document
		guard let node = xDoc?.documentElement?.getElementsByTagName(tagName) else {
			print("There is no such a tag: `\(tagName)`\n")
			return
		}

		// if is, get the first matched
		guard let value = node.first?.nodeValue else {
			print("Tag `\(tagName)` has no value\n")
			return
		}

		// show the node value
		print("Tag '\(tagName)' has a value of '\(value)'\n")
}

testTag(tagName: "link")
testTag(tagName: "description")

print("=====================================================================\n")
print("Test ID\n")

func testID(id: String) {

		// Access node by its id, if available
		guard let node = xDoc?.getElementById(id) else {
			print("There is no such a id: `\(id)`\n")
			return
		}

		guard let value = node.nodeValue else {
			print("id `\(id)` has no value\n")
			return
		}

		print("id '\(id)' has a value of '\(value)'\n")
}

testID(id: "rssID")
testID(id: "xmlID")

print("=====================================================================\n")
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

print("=====================================================================\n")
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

print("=====================================================================\n")

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
print("=====================================================================\n")

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

print("=====================================================================\n")

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
print("=====================================================================\n")

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

print("=====================================================================\n")

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
