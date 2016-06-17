//
//  MasterViewController.swift
//  CoolReader
//
//  Created by Austin Felipe on 2016-06-16.
//  Copyright © 2016 Austin Felipe. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements: NSMutableDictionary = [:]
    var element: NSString = ""
    var postTitle: NSMutableString = ""
    var postDate: NSMutableString = ""
    var postUrl: NSMutableString = ""
    
    // Configuration
    let rssUrl = NSURL(string: "http://tecnologia.uol.com.br/ultnot/index.xml")!
    let ITEM_NODE_NAME = "item"
    let TITLE_NODE_NAME = "title"
    let DATE_NODE_NAME = "pubDate"
    let LINK_NODE_NAME = "link"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Parse functions
    func beginParsing() {
        posts = []
        parser = NSXMLParser(contentsOfURL: rssUrl)!
        parser.delegate = self
        parser.parse()
        self.tableView.reloadData()
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName
        
        if (elementName as NSString).isEqualToString(ITEM_NODE_NAME) {
            elements = [:]
            postTitle = ""
            postDate = ""
            postUrl = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if element.isEqualToString(TITLE_NODE_NAME) {
            
            postTitle.appendString(string)
            postTitle = NSMutableString(string: postTitle
                .stringByReplacingOccurrencesOfString("&#039;", withString: "'")
                .stringByReplacingOccurrencesOfString("&rsquo;", withString: "'")
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        } else if element.isEqualToString(DATE_NODE_NAME) {
            postDate.appendString(string)
        } else if element.isEqualToString(LINK_NODE_NAME) {
            postUrl.appendString(string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqualToString(ITEM_NODE_NAME) {
            if !postTitle.isEqual(nil) {
                elements.setObject(postTitle, forKey: "title")
            }
            
            if !postDate.isEqual(nil) {
                elements.setObject(postDate, forKey: "date")
            }
            
            if !postUrl.isEqual(nil) {
                elements.setObject(postUrl, forKey: "url")
            }
            
            posts.addObject(elements)
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let postItem = posts.objectAtIndex(indexPath.row)
                ((segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController).detailItem = postItem
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("title") as? String
        cell.detailTextLabel?.text = posts.objectAtIndex(indexPath.row).valueForKey("date") as? String
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

}

