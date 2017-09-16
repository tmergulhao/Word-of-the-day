//
//  WordModel.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

final class WordModel : NSObject {
    
    // MARK : Singleton
    
    static let shared = WordModel()
    
    private override init() {}
    
    // MARK : Properties
    
    var word : Word?
    
    // MARK : XMLParserDelegate
    
    var parser : XMLParser!
    var stack = Array<NSMutableDictionary>()
    var textInProgress : String = ""
    
    // MARK : URLSessionDownloadDelegate
    
    var audioURL : URL?
    var progressDisplay : ProgressDisplay?
    
    // MARK: Singleton binding
    
    class var progressDisplay : ProgressDisplay? {
        get {
            return shared.progressDisplay
        }
        set(newValue) {
            shared.progressDisplay = newValue
        }
    }
    class var word : Word? { return shared.word }
    class var audioURL : URL? { return shared.audioURL }
    class func loadWord () { shared.loadWord() }
    class func loadAudio () { shared.loadAudio() }
}
