//
//  IntroductionController+Ambience.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 25/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import STAmbience

extension IntroductionController : AmbienceListener {
    func ambience(didChangeFrom previousState: AmbienceState?, to currentState: AmbienceState) {
        
        switch currentState {
        case .Invert: print("Invert")
        case .Regular: print("Regular")
        case .Contrast: print("Contrast")
        }
    }
}
