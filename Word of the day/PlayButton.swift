//
//  PlayButton.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 23/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

@IBDesignable class PlayButton : UIButton {
    
    override class var layerClass : Swift.AnyClass { return PlayButtonLayer.self }
    
    override func draw(_ rect: CGRect) {}
    
    var onOffState : Bool = false {
        didSet {
            let customLayer = layer as! PlayButtonLayer
            customLayer.ratio = onOffState ? 1 : 0
        }
    }
    
    func switchOnOffState() {
        onOffState = !onOffState
    }
}
