//
//  Word.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

struct Word {
    
    var link : String
    var audioURL : URL
    var title : String
    var shortDefinition : String
    var definition : String
    
    init?(_ dictionary : Dictionary<String, Any>) {
        
        guard let dict = dictionary as? Dictionary<String, Dictionary<String, String>> else { return nil }
        
        guard let link = dict["link"]?["text"] else { return nil }
        guard let audioPath = dict["enclosure"]?["url"] else { return nil }
        guard let audioURL = URL(string: audioPath) else { return nil }
        guard let shortDefinition = dict["merriam:shortdef"]?["text"] else { return nil }
        guard let title = dict["title"]?["text"] else { return nil }
        guard let definition = dict["description"]?["text"] else { return nil }
        
        self.link = link
        self.audioURL = audioURL
        self.shortDefinition = shortDefinition
        self.title = title
        self.definition = definition
    }
}

extension Word : CustomStringConvertible {
    var description : String {
        return title
    }
}
