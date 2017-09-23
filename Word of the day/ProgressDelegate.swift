//
//  ProgressDisplay.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

protocol ProgressDelegate {
    func didProgress(_ progress : Float)
    func reachedError()
    func didComplete()
}
