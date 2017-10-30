//
//  StyleKit.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 20/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init (named name: String, fallback color : UIColor) {
        if #available(iOS 11, *) {
            self.init(named: name)!
        } else {
            self.init(cgColor: color.cgColor)
        }
    }
}

class StyleKit {
    struct color {
        static var null : UIColor = UIColor(named: "Nil", fallback: #colorLiteral(red: 0.9990229011, green: 0.9928569198, blue: 0.9751904607, alpha: 1))
        static var tint : UIColor = UIColor(named: "Tint", fallback: #colorLiteral(red: 0.9987789989, green: 0.2811864614, blue: 0.3146876097, alpha: 1))
        static var ink : UIColor = UIColor(named: "Ink", fallback: #colorLiteral(red: 0.03442871943, green: 0.03442871943, blue: 0.03442871943, alpha: 1))
        static var white : UIColor = UIColor.white
    }
}
