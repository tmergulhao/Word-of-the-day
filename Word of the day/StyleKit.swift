//
//  StyleKit.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 20/10/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class StyleKit {
    struct color {
        static var null : UIColor = {
            if #available(iOS 11, *) {
                return UIColor(named: "Nil")!
            } else {
                return UIColor.white
            }
        }()
    }
}
