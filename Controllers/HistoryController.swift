//
//  HistoryController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/11/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import Ambience

class HistoryController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var loadingButton: LoadingButton!
    
    var selected : IndexPath!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Definition" {
            let definition = segue.destination as? DefinitionController
            
            definition?.word = WordModel.words[selected.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Ambience.add(listener: self)
        
        WordModel.progressDelegate = self
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 136, 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Ambience.remove(listener: self)
    }
    
    var ambienceState : AmbienceState = .Regular
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return ambienceState == .Invert ? .lightContent : .default
    }
}

extension HistoryController : ProgressDelegate {
    
    func didComplete() {
        loadingButton.didComplete()
    }
    
    func didProgress(_ progress: Float) {
        
        loadingButton.didProgress(progress)
    }
    
    func reachedError() {
        
        let alert = UIAlertController(
            title:"Shoot!",
            message:"There was something wrong with the audio episode… Would you like to play the game anyway?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        loadingButton.alpha = 0.4
        loadingButton.reachedError()
    }
}

extension HistoryController : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        ambienceState = currentState
        
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension HistoryController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            selected = indexPath
            performSegue(withIdentifier: "Definition", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return WordModel.words.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath) as? WordCell else {
                return UITableViewCell()
            }
            
            cell.title.text = WordModel.words[indexPath.row].title
            cell.shortDefinition.text = WordModel.words[indexPath.row].shortDefinition
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}
