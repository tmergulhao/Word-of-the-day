//
//  LoadingButton.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

@IBDesignable class LoadingButton : UIButton {
    
    var progress : Float = 0 {
        didSet {
            setNeedsDisplay()
            print("Asked")
        }
    }
    
    override func draw(_ rect: CGRect) {

        let circlePath = UIBezierPath(ovalIn: rect)
        #colorLiteral(red: 0.9459537864, green: 0.4344328642, blue: 0.4142383933, alpha: 1).setFill()
        circlePath.fill()
        
        print("Done")
        
        let lineWidth : CGFloat = 5
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius : CGFloat = max(rect.width, rect.height)
        let startAngle : CGFloat = -.pi/2
        let endAngle : CGFloat = (CGFloat(progress) * 2 * .pi) - (.pi/2)
        let progressPath = UIBezierPath(arcCenter: center,
                                radius: radius/2 - lineWidth + 2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        progressPath.lineWidth = lineWidth
        #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1).setStroke()
        progressPath.stroke()
    }
}
