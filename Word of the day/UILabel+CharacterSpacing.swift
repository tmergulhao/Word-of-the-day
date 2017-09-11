//
//  UILabel+CharacterSpacing.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 11/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension UILabel {
    func setCharactersSpacing(_ spacing : CGFloat) {
        
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: spacing, range: NSMakeRange(0, text.characters.count))
        attributedText = attributedString
    }
}
