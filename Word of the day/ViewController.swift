//
//  ViewController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet var keyboardLabel : UILabel!
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var keyboard : Array<UIButton>!
    @IBOutlet var activity : UIActivityIndicatorView!

    var word : Word?
    var charactersUsed : Set<Character> = []
    var localAudioURL : URL?
    
    func setWordDisplay () {
        
        guard let word = self.word else { return }
        
        let maskedText = String(word.title.characters.map({
            switch $0 {
            case " ": return " "
            case let x where charactersUsed.contains(x) : return x
            default: return "_"
            }
        }))
        
        wordLabel.text = maskedText
        wordLabel.setCharactersSpacing(5)
        
        if maskedText == word.title {
            player.volume = 1.0
            player.play()
        }
    }
    
    @IBAction func keyboardPressed(_ sender : UIButton) {
        sender.isEnabled = false
        
        let character : Character! = sender.titleLabel?.text?.lowercased().characters.first
        
        charactersUsed.insert(character)
        
        setWordDisplay()
    }
    
    func loadWord () {
        
        let url : URL! = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2")
        let contents = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        
        let XML : XMLDictionary! = getdictionaryFromXmlString(xmldata: contents)![0] as? XMLDictionary
        let data = (((XML["rss"]! as! XMLDictionary)["channel"]! as! XMLDictionary)["item"]! as! Array<XMLDictionary>) [0]
        
        guard let word = Word(data) else { print("Unable to parse word from XML"); return }
        
        self.word = word
    }
    
    func loadAudio () {
        
        guard let word = self.word else { return }
        
        let downloadTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: word.audioURL, completionHandler: { [weak self](url, response, error) -> Void in
            
            self?.activity.stopAnimating()
            
            self?.player = try? AVAudioPlayer(contentsOf: url!)
            self?.player.prepareToPlay()
        })
        
        downloadTask.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in keyboard {
            button.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
        }
        
        loadWord()
        
        setWordDisplay()
        
        loadAudio()
        
        // webView.loadHTMLString(word!.definition, baseURL: nil)
    }
    
    var player : AVAudioPlayer!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK : XMLParserDelegate
    
    var parser : XMLParser!
    var stack = Array<NSMutableDictionary>()
    var textInProgress : String = ""
}
