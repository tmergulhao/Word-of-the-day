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
            
        guard let url : URL = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2") else { throw XMLError.URL }
        guard let dictionary = self.getDictionaryFromXML(url: url)?[0] else { throw XMLError.XMLParsing }
        guard let data = (dictionary.value(forKeyPath: "rss.channel.item") as? Array<XMLDictionary>) else { throw XMLError.XMLStructure }
        
        let newWords = data.map({
            (data : XMLDictionary) -> Word? in
            
            let word = Word(data)
            
            // if word == nil { throw XMLError.XMLSyntax }
            
            return word
        }).filter { $0 != nil }.map { $0! }.reduce(into: Dictionary<String,Word>()) { ( result : inout Dictionary<String,Word>, value : Word) in
            result[value.title] = value
        }

        if words.value == nil { words.value = [:] }

        words.value = words.value!.merging(newWords, uniquingKeysWith: { (previous, newValue) -> Word in
            return previous
        })

        WordModel.update()
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
            
            if let array = value as? NSMutableArray {
                array.add(dictionary)
            } else {
                let array = NSMutableArray()
                array.add(value)
                array.add(dictionary)
                stack.last![elementName] = array
            }
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
