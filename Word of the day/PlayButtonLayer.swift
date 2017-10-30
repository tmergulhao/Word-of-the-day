//
//  PlayButtonLayer.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 23/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import QuartzCore
import UIKit

class PlayButtonLayer : CALayer {
    
    @NSManaged var ratio : CGFloat
    
    override init() { super.init() }
    
    override init(layer: Any) { super.init(layer: layer) }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        
        switch key {
            
        case #keyPath(ratio): return true
            
        default: return super.needsDisplay(forKey : key)
            
        }
    }
    
    override func action(forKey event: String) -> CAAction? {
        
        switch event {
            
        case #keyPath(ratio):
            
            let animation = CABasicAnimation(keyPath: event)
            
            animation.fromValue = presentation()?.value(forKey: event)
            animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
            animation.duration = 0.5
            
            return animation
            
        default: return super.action(forKey: event)
        }
    }
    
    override func draw(in ctx: CGContext) {
        
        let resizing : ResizingBehavior = .aspectFit
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 78, height: 78), target: bounds)
        
        let path = CGMutablePath()
        
        let playPathPoints = [
            CGPoint(x: 40, y: 28),
            CGPoint(x: 40, y: 100),
            CGPoint(x: 100, y: 64),
            CGPoint(x: 100, y: 64),
            ]
        
        let stopPathPoints = [
            CGPoint(x: 30, y: 30),
            CGPoint(x: 30, y: 98),
            CGPoint(x: 98, y: 98),
            CGPoint(x: 98, y: 30),
            ]
        
        let ratio = self.ratio
        let points = zip(stopPathPoints, playPathPoints).map {
            return CGPoint(
                x: $0.x * ratio + $1.x * (1 - ratio),
                y: $0.y * ratio + $1.y * (1 - ratio))
        }
        
        path.move(to: points.last!)
        path.addLines(between: points)
        path.closeSubpath()
        
        var scale = CGAffineTransform(scaleX: resizedFrame.width / 128, y: resizedFrame.height / 128)
        var translate = CGAffineTransform(translationX: resizedFrame.minX, y: resizedFrame.minY)
        
        let clipping = path.copy(using: &scale)!.copy(using: &translate)!
        
        let color : CGColor! = StyleKit.color.tint.cgColor
        
        ctx.saveGState()
        ctx.addPath(clipping)
        
        ctx.setFillColor(color)
        ctx.fillPath()
        
        ctx.restoreGState()
    }
}
