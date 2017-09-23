//
//  WordModel+XMLParserDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

extension WordModel : XMLParserDelegate {
    
    enum XMLError : Error, CustomStringConvertible {
        case URL
        case XMLSyntax
        case XMLStructure
        case XMLParsing
        
        var description: String {
            switch self {
            case .URL: return "Unable to instanciate URL"
            case .XMLSyntax: return "Unable to parse XML"
            case .XMLStructure: return "Unable to traverse through data"
            case .XMLParsing: return "Unable to parse word from XML"
            }
        }
    }
    
    func loadWord() throws {
            
        guard let url : URL = URL(string: "http://webster.com/word/index.xml") else { throw XMLError.URL }
        guard let xml = self.getDictionaryFromXML(url: url)?[0] else { throw XMLError.XMLParsing }
        guard let data = (xml.value(forKeyPath: "rss.channel.item") as? Array<XMLDictionary>)?.first else { throw XMLError.XMLStructure }
        guard let word = Word(data) else { throw XMLError.XMLSyntax }
        
        self.word = word
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
