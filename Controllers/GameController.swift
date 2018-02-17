//
//  GameController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import Ambience

class GameController: UIViewController {
    
    @IBOutlet var hintLabel : UILabel!
    @IBOutlet var wordLabel : UILabel!
    @IBOutlet var keyboard : Array<UIButton>!
    @IBOutlet var keyboardStack : UIStackView!
    
    @IBOutlet var titleCenterY: NSLayoutConstraint!
    @IBOutlet var titleSpacingTop: NSLayoutConstraint!
    @IBOutlet var keyboardHideGuide: NSLayoutConstraint!
    @IBOutlet weak var keyboardShowGuide: NSLayoutConstraint!

    var charactersUsed : Set<Character> = []
    
    func setWordDisplay () {
        
        guard let word = WordModel.first else { return }

        var sanitized = word.title

        sanitized.applyingTransform(.stripCombiningMarks, reverse: false)
        
        let maskedText = String(sanitized.map({
            switch $0 {
            case let x where x == " " || x == "-": return x
            case let x where charactersUsed.contains(x) : return x
            default: return "_"
            }
        }))
        
        wordLabel.text = maskedText
        wordLabel.setCharactersSpacing(5)
        
        if maskedText == word.title {
            performSegue(withIdentifier: "Definition", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Definition" {
            
            let definition = segue.destination as? DefinitionController
            
            definition?.word = WordModel.first
        }
    }
    
    @IBAction func keyboardPressed(_ sender : UIButton) {
        
        sender.isEnabled = false
        sender.alpha = 0.4
        
        let character : Character! = sender.titleLabel?.text?.lowercased().first
        
        charactersUsed.insert(character)
        
        setWordDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [titleSpacingTop].deactivate()
        view.layoutIfNeeded()
        
        for button in keyboard {
            button.addTarget(self, action: #selector(keyboardPressed(_:)), for: .touchUpInside)
        }
        
        self.hintLabel.text = WordModel.first?.shortDefinition
        
        setWordDisplay()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return Ambience.currentState == .invert ? .lightContent : .default
    }
}

// MARK: - Ambience Listener

extension GameController {
    
    @objc public override func ambience(_ notification : Notification) {
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
