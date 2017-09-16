//
//  GameToDefinitionSegue.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class GameToDefinitionSegue : CrossfadeSegue {
    override func perform () {
        
        guard let game = source as? GameController else {
            print("Crossfade Segue unable to instanciate Game Controller")
            return
        }
        
        [game.titleCenterY, game.keyboardShowGuide].deactivate()
        [game.titleSpacingTop, game.keyboardHideGuide].activate()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            
            self!.source.view.layoutIfNeeded()
        })
        
        super.perform()
    }
}
