//
//  ViewController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

typealias XMLDictionary = Dictionary<String,Any>

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url : URL! = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2")
        let contents = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        
        let XML : XMLDictionary! = getdictionaryFromXmlString(xmldata: contents)![0] as? XMLDictionary
        let data = (((XML["rss"]! as! XMLDictionary)["channel"]! as! XMLDictionary)["item"]! as! Array<XMLDictionary>) [0]
        let word : Word? = Word(data)
        
        print(word!.definition)
        
        webView.loadHTMLString(word!.definition, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : XMLParserDelegate
    
    var parser : XMLParser!
    var stack = Array<NSMutableDictionary>()
    var textInProgress : String = ""
}
