//
//  GameController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    
    @IBOutlet var hintLabel : UILabel!
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var keyboard : Array<UIButton>!
    var charactersUsed : Set<Character> = []
    
    func setWordDisplay () {
        
        guard let word = WordModel.word else { return }
        
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
            AudioPlayer.shared.play()
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
        
        self.hintLabel.text = WordModel.word!.shortDefinition
        
        setWordDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
