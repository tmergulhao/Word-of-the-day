//
//  LoadingButtonLayer.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import QuartzCore
import UIKit

class LoadingButtonLayer : CALayer {
    
    @NSManaged var progress : CGFloat
    
    override init() { super.init() }
    
    override init(layer: Any) { super.init(layer: layer) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        
        switch key {
            
        case #keyPath(progress): return true
            
        default: return super.needsDisplay(forKey : key)
            
        }
    }
    
    override func action(forKey event: String) -> CAAction? {
        
        switch event {
            
        case #keyPath(progress):
            
            let animation = CABasicAnimation(keyPath: event)
            
            animation.fromValue = presentation()?.value(forKey: event)
            animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
            animation.duration = 0.2
            
            return animation
            
        default: return super.action(forKey: event)
        }
    }
    
    func drawProgess(in ctx: CGContext) {
        
        let lineWidth : CGFloat = 5
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius : CGFloat = max(bounds.width, bounds.height)
        let startAngle : CGFloat = -.pi/2
        let endAngle : CGFloat = (CGFloat(progress) * 2 * .pi) - (.pi/2)
        let progressPath = UIBezierPath(arcCenter: center,
                                        radius: radius/2 - lineWidth + 2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        let progressBar = progressPath.cgPath
        
        let color : CGColor = StyleKit.color.null.cgColor
        
        ctx.setLineWidth(3)
        ctx.setStrokeColor(color)
        ctx.addPath(progressBar)
        ctx.strokePath()
    }
    
    override func draw(in ctx: CGContext) {
        
        let circle = CGPath(ellipseIn: bounds, transform: nil)
        
        let color : CGColor = StyleKit.color.tint.cgColor
        
        ctx.setFillColor(color)
        ctx.addPath(circle)
        ctx.fillPath()
        
        if progress < 1 { drawProgess(in: ctx) }
    }
}
