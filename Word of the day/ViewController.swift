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
    
    @IBOutlet var hintLabel : UILabel!
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var keyboard : Array<UIButton>!
    var charactersUsed : Set<Character> = []
    var localAudioURL : URL?
    
    var word : Word? = nil
    var audioURL : URL? = nil
    
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
            player?.volume = 1.0
            player?.play()
        }
    }
    
    @IBAction func keyboardPressed(_ sender : UIButton) {
        
        sender.isEnabled = false
        sender.layer.opacity = 0.4
        
        let character : Character! = sender.titleLabel?.text?.lowercased().characters.first
        
        charactersUsed.insert(character)
        
        setWordDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in keyboard {
            button.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
        }
        
        self.hintLabel.text = word!.shortDefinition
        
        setWordDisplay()
        
        player = try? AVAudioPlayer(contentsOf: audioURL!)
        player?.prepareToPlay()
        
        // webView.loadHTMLString(word!.definition, baseURL: nil)
    }
    
    var player : AVAudioPlayer?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
