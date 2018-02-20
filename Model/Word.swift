//
//  Word.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation
import CoreData

typealias XMLDictionary = Dictionary<String,Any>

class Word : Codable {
    
    var link : String
    var externalAudioURL : URL
    var title : String
    var shortDefinition : String
    var definition : String
    var audioURL : URL?
    var date : Date
    
    init?(_ dictionary : XMLDictionary) {

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "eee, d MMM yyyy hh:mm:ss ZZZ"
        
        guard   let dict = dictionary as? Dictionary<String, Dictionary<String, String>>,
                let link = dict["link"]?["text"],
                let audioPath = dict["enclosure"]?["url"],
                let externalAudioURL = URL(string: audioPath),
                let shortDefinition = dict["merriam:shortdef"]?["text"],
                let title = dict["title"]?["text"],
                let definition = dict["description"]?["text"],
                let dateString = dict["pubDate"]?["text"],
                let date = dateFormater.date(from: dateString) else { return nil }

        self.link = link
        self.externalAudioURL = externalAudioURL
        self.shortDefinition = shortDefinition
        self.title = title
        self.definition = definition
        self.date = date
    }
}

extension Word : CustomStringConvertible {
    var description : String {
        return title + "\n" + link + "\n" + shortDefinition + "\n" + definition
    }
}
