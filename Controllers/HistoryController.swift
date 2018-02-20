//
//  HistoryController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/11/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class HistoryController : UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Definition", let sender = sender as? IndexPath {
            
            let definition = segue.destination as? DefinitionController
            
            definition?.word = WordModel.words[sender.row]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.font : UIFont(name: "PlayfairDisplay-Regular", size: 34)!
        ]
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font : UIFont(name: "PlayfairDisplay-Regular", size: 20)!
        ]
        
        navigationController?.navigationBar.backItem?.title = ""
    }
}

extension HistoryController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "Definition", sender: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HistoryController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return WordModel.words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath) as? WordCell else {
            return UITableViewCell()
        }

        let word = WordModel.words[indexPath.row]
        
        cell.title.text = word.title
        cell.shortDefinition.text = word.shortDefinition
        
        return cell
    }
}
