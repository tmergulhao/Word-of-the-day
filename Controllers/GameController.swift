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
        
        guard let word = WordModel.word else { return }
        
        let maskedText = String(word.title.map({
            switch $0 {
            case let x where x == " " || x == "-": return x
            case let x where charactersUsed.contains(x) : return x
            default: return "_"
            }
        }))
        
        wordLabel.text = maskedText
        wordLabel.setCharactersSpacing(5)
        
        if maskedText == word.title {
            performSegue(withIdentifier: "display definition", sender: nil)
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
        
        self.hintLabel.text = WordModel.word!.shortDefinition
        
        setWordDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Ambience.add(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Ambience.remove(listener: self)
    }
    
    var ambienceState : AmbienceState = .Regular
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return ambienceState == .Invert ? .lightContent : .default
    }
}

// MARK: - Ambience Listener

extension GameController : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        ambienceState = currentState
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
