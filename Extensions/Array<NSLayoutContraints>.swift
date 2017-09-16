//
//  Array<NSLayoutContraints>.swift
//  Meditate
//
//  Created by Tiago Mergulhão on 06/02/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension Array where Element : NSLayoutConstraint {
	func activate () { NSLayoutConstraint.activate(self) }
    func deactivate () { NSLayoutConstraint.deactivate(self) }
}
