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

final class Wordd : NSManagedObject {
    @NSManaged fileprivate(set) var played : Bool
    @NSManaged fileprivate(set) var date : Date
    @NSManaged fileprivate(set) var dictionary : XMLDictionary
    @NSManaged fileprivate(set) var link : URL
    @NSManaged fileprivate(set) var audioURL : URL
    @NSManaged fileprivate(set) var externalAudioURL : URL
    @NSManaged fileprivate(set) var shortDefinition : String
    @NSManaged fileprivate(set) var title : String
    @NSManaged fileprivate(set) var definition : NSAttributedString
}

struct WordStruct {
    
    var link : String
    var externalAudioURL : URL
    var title : String
    var shortDefinition : String
    var definition : String
    var audioURL : URL?
    
    init?(_ dictionary : XMLDictionary) {
        
        guard   let dict = dictionary as? Dictionary<String, Dictionary<String, String>>,
                let link = dict["link"]?["text"],
                let audioPath = dict["enclosure"]?["url"],
                let externalAudioURL = URL(string: audioPath),
                let shortDefinition = dict["merriam:shortdef"]?["text"],
                let title = dict["title"]?["text"],
                let definition = dict["description"]?["text"] else { return nil }

        self.link = link
        self.externalAudioURL = externalAudioURL
        self.shortDefinition = shortDefinition
        self.title = title
        self.definition = definition
    }
}

extension WordStruct : CustomStringConvertible {
    var description : String {
        return title + "\n" + link + "\n" + shortDefinition + "\n" + definition
    }
}

protocol Managed : class, NSFetchRequestResult {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension Managed {
    static var defaultSortDescriptor : [NSSortDescriptor] {
        return []
    }
    static var sortedFetchRequest : NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptor
        return request
    }
}

extension Managed where Self : NSManagedObject {
    static var entityName : String { return entity().name! }
}
