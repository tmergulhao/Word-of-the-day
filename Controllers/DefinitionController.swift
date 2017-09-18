//
//  DefinitionController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import SafariServices

class DefinitionController : UITableViewController {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var shortDefinitionLabel: UILabel!
    @IBOutlet weak var fullDefinitionLabel: UILabel!
    
    @IBAction func viewPodcast(_ sender: UIButton) {
        
        let url : URL! = URL(string: "https://itunes.apple.com/us/podcast/merriam-websters-word-of-the-day/id164829166")
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func viewOnWebsite(_ sender: UIButton) {
        
        let url : URL! = URL(string: WordModel.word!.link)
        let safari = SFSafariViewController(url: url)
        let tint = UIColor(named: "Tint red")
        safari.preferredControlTintColor = tint
        present(safari, animated: true, completion: nil)
    }
    @IBAction func playPause(_ sender: UIButton) {
        AudioPlayer.shared.play()
    }
    @IBAction func lookUp(_ sender: UIButton) {
        
        guard let word = WordModel.word else { return }
        
        present( UIReferenceLibraryViewController(term: word.title), animated: true, completion: nil)
    }
    @IBOutlet var cell : UITableViewCell!
    
    override func viewDidLoad() {
        
        guard let word = WordModel.word else { return }
        
        wordLabel.text = word.title
        wordLabel.setCharactersSpacing(5)
        shortDefinitionLabel.text = word.shortDefinition
        fullDefinitionLabel.text = word.definition
        
        if !UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: word.title) {
            cell.removeFromSuperview()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
