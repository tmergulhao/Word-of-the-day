//
//  Word.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

typealias XMLDictionary = Dictionary<String,Any>

struct Word {
    
    var link : String
    var audioURL : URL
    var title : String
    var shortDefinition : String
    var definition : String
    
    init?(_ dictionary : XMLDictionary) {
        
        guard   let dict = dictionary as? Dictionary<String, Dictionary<String, String>>,
                let link = dict["link"]?["text"],
                let audioPath = dict["enclosure"]?["url"],
                let audioURL = URL(string: audioPath),
                let shortDefinition = dict["merriam:shortdef"]?["text"],
                let title = dict["title"]?["text"],
                let definition = dict["description"]?["text"] else { return nil }
        
        self.link = link
        self.audioURL = audioURL
        self.shortDefinition = shortDefinition
        self.title = title
        self.definition = definition
    }
}

extension Word : CustomStringConvertible {
    var description : String {
        return title + "\n" + link + "\n" + shortDefinition + "\n" + definition
    }
}
