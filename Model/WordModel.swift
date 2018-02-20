//
//  WordModel.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

typealias Words = Dictionary<String, Word>

final class WordModel : NSObject {
    
    // MARK : Singleton
    
    static let shared = WordModel()
    
    private override init() {}
    
    // MARK : Properties

    var words = Default<Words>(key: "words")
    
    // MARK : XMLParserDelegate
    
    var parser : XMLParser!
    var stack = Array<NSMutableDictionary>()
    var textInProgress : String = ""
    
    // MARK : URLSessionDownloadDelegate
    
    var audioURL : URL?
    var progressDelegate : ProgressDelegate?
    
    // MARK: Singleton binding

    class func update () {
        let dictionary = shared.words.value
        shared.words « nil
        shared.words « dictionary
    }
    
    class var progressDelegate : ProgressDelegate? {
        get {
            return shared.progressDelegate
        }
        set(newValue) {
            shared.progressDelegate = newValue
        }
    }
    class var words : Array<Word> {
        let wordsArray = Array(shared.words.value!.values)
        return wordsArray.sorted { $0.date > $1.date }

    }
    class var audioURL : URL? { return shared.audioURL }
    class var first : Word? {
        guard let word = words.first else { return nil }
        return word
    }
}
