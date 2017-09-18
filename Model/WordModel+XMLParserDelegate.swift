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
            
            guard let url : URL = URL(string: "http://webster.com/word/index.xml") else {
                print("Unable to instanciate URL")
                return
            }
            guard let xml = self?.getDictionaryFromXML(url: url)?[0] else {
                print("Unable to parse XML")
                return
            }
            guard let data = (xml.value(forKeyPath: "rss.channel.item") as? Array<XMLDictionary>)?.first else {
                print("Unable to traverse through data")
                return
            }
            
            guard let word = Word(data) else {
                print("Unable to parse word from XML")
                return
            }
            
            self?.word = word
            
            DispatchQueue.main.sync {
                self?.loadAudio()
            }
        }
    }
    
    func getDictionaryFromXML(url : URL) -> Array<NSMutableDictionary>? {
        
        stack.append(NSMutableDictionary())
        
        guard let parser = XMLParser(contentsOf: url) else {
            print("Unable to instanciate parser using URL")
            return nil
        }
        
        parser.delegate = self
        parser.parse()
        
        return stack
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
}
