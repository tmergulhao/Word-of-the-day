//
//  LoadingButton.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

@IBDesignable class LoadingButton : UIButton, ProgressDisplay {
    
    var progress : Float = 0 {
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
