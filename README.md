# rssreader-ios
A simples project that shows how to parse a RSS XML feed and work with UIWebView

## Configuration

In order to change the app RSS's configuration, locate the lines below inside **MasterViewController.swift**

    // Configuration
    let rssUrl = NSURL(string: "http://tecnologia.uol.com.br/ultnot/index.xml")!
    let ITEM_NODE_NAME = "item"
    let TITLE_NODE_NAME = "title"
    let DATE_NODE_NAME = "pubDate"
    let LINK_NODE_NAME = "link"
