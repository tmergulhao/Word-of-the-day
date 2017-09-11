//
//  ViewController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import AVFoundation

typealias XMLDictionary = Dictionary<String,Any>

class ViewController: UIViewController {

    // @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet var keyboardLabel : UILabel!
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var keyboard : Array<UIButton>!
    @IBOutlet var activity : UIActivityIndicatorView!

    var word : Word!
    var charactersUsed : Set<Character> = []
    var localAudioURL : URL?
    
    func setWordDisplay () {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in keyboard {
            button.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
        }
        
        let url : URL! = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2")
        let contents = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        
        let XML : XMLDictionary! = getdictionaryFromXmlString(xmldata: contents)![0] as? XMLDictionary
        let data = (((XML["rss"]! as! XMLDictionary)["channel"]! as! XMLDictionary)["item"]! as! Array<XMLDictionary>) [0]
        
        word = Word(data)
        
        let downloadTask : URLSessionDownloadTask = URLSession.shared.downloadTask(with: word.audioURL, completionHandler: { [weak self](url, response, error) -> Void in

            self?.activity.stopAnimating()
            
            do {
                self?.player = try AVAudioPlayer(contentsOf: url!)
                self?.player.prepareToPlay()
            } catch let error as Error {
                print(error.localizedDescription)
            }
        })
        
        downloadTask.resume()
        
        setWordDisplay()
        
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
