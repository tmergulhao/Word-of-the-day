//
//  DefinitionController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class DefinitionController : UITableViewController {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var shortDefinitionLabel: UILabel!
    @IBOutlet weak var fullDefinitionLabel: UILabel!
    @IBAction func viewPodcast(_ sender: UIButton) {
        print("Unable to launch Podcast url yet")
    }
    @IBAction func viewOnWebsite(_ sender: UIButton) {
        print("Unable to launch M.W. url yet")
    }
    @IBAction func playPause(_ sender: UIButton) {
        AudioPlayer.shared.play()
    }
    
    override func viewDidLoad() {
        
        guard let word = WordModel.word else { return }
        
        wordLabel.text = word.title
        wordLabel.setCharactersSpacing(5)
        shortDefinitionLabel.text = word.shortDefinition
        fullDefinitionLabel.text = word.definition
    }
}
