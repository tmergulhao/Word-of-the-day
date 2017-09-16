//
//  WordModel+XMLParserDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

extension WordModel : XMLParserDelegate {
    
    func loadWord() {
        
        DispatchQueue.global(qos: .background).async {
            [weak self]() -> Void in

            let url : URL! = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2")
            let contents = try! String(contentsOf: url, encoding: String.Encoding.utf8)
            
            let XML : XMLDictionary! = self?.getdictionaryFromXmlString(xmldata: contents)![0] as? XMLDictionary
            let data = (((XML["rss"]! as! XMLDictionary)["channel"]! as! XMLDictionary)["item"]! as! Array<XMLDictionary>) [0]
            
            guard let word = Word(data) else { print("Unable to parse word from XML"); return }
            
            self?.word = word
            
            DispatchQueue.main.sync {
                self?.loadAudio()
            }
        }
    }
    
    func getdictionaryFromXmlData(xmldata : Data) -> Array<NSMutableDictionary>? {
        
        stack.append(NSMutableDictionary())
        
        parser = XMLParser(data: xmldata)
        parser.delegate = self
        parser.parse()
        
        return stack
    }
    
    func getdictionaryFromXmlString(xmldata : String) -> Array<NSMutableDictionary>? {
        
        return getdictionaryFromXmlData(xmldata: xmldata.data(using: .utf8)!)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        let dictionary = NSMutableDictionary()
        dictionary.addEntries(from: attributeDict)
        
        if let value = stack.last?[elementName] {
            
            var array = Array<Any>()
            
            if value is Array<Any> {
                array = value as! Array<AnyObject>
            } else {
                array.append(value as AnyObject)
                stack[stack.count-1][elementName] = array
            }
            
            array.append(dictionary)
        } else {
            stack[stack.count - 1][elementName] = dictionary
        }
        
        stack.append(dictionary)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        let dictInProgress = stack.last
        
        if textInProgress.lengthOfBytes(using: .utf8) > 0 {
            dictInProgress?["text"] = textInProgress
            textInProgress = ""
        }
        
        stack.removeLast()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textInProgress += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {}
}
