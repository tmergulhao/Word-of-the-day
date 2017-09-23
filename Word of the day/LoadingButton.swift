//
//  LoadingButton.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

@IBDesignable class LoadingButton : UIButton {
    
    var progress : Float = 0.0 {
        didSet {
            
            isEnabled = progress == 1
            
            let customLayer = layer as! LoadingButtonLayer
            customLayer.progress = CGFloat(progress)
            setNeedsDisplay()
        }
    }
    
    override class var layerClass : Swift.AnyClass { return LoadingButtonLayer.self }
    
    override func draw(_ rect: CGRect) {}
}

extension LoadingButton : ProgressDelegate {
    func didComplete() {
        progress = 1.0
    }
    func didProgress(_ progress: Float) {
        self.progress = progress
    }
    func reachedError() {
        progress = 0.0
    }
}
