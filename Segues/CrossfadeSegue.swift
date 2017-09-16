//
//  CrossfadeSegue.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class CrossfadeSegue : UIStoryboardSegue {
    override func perform () {
        
        let window = UIApplication.shared.keyWindow!
        let source = self.source
        let destination = self.destination
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, aboveSubview: source.view)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            destination.view.alpha = 1.0
        }) {
            (completion) in
            source.view.alpha = 1.0
            source.present(destination, animated: false, completion: nil)
        }
    }
}
