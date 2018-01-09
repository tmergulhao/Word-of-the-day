//
//  WordCell.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/11/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class WordCell : UITableViewCell {
    @IBOutlet var title : UILabel!
    @IBOutlet var shortDefinition : UILabel!
    
    func configure (for word : WordStruct) {
        
        title.text = word.title
        shortDefinition.text = word.shortDefinition
    }
}
