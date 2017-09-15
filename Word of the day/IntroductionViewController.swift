//
//  IntroductionViewController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 13/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class IntroductionViewController : UIViewController {
    
    var word : Word?
    
    // MARK : XMLParserDelegate
    
    var parser : XMLParser!
    var stack = Array<NSMutableDictionary>()
    var textInProgress : String = ""
    
    // MARK : URLSessionDownloadDelegate
    
    var audioURL : URL?
    
    // MARK : UIView
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var buttonCenterY: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottonToView: NSLayoutConstraint!
    @IBOutlet weak var buttonSmallerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loadingButton: LoadingButton!
    
    func performButtonMove () {
        
        UIView.animate(withDuration: 2, delay: 2, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            
            guard   let buttonHeight = self?.buttonHeight,
                let buttonCenterY = self?.buttonCenterY,
                let buttonBottonToView = self?.buttonBottonToView,
                let buttonSmallerHeight = self?.buttonSmallerHeight else {
                    return
            }
            
            [buttonCenterY, buttonHeight].deactivate()
            [buttonBottonToView, buttonSmallerHeight].activate()
            
            self?.view.layoutIfNeeded()
            
        }) { [weak self](completion) in
            
            self?.loadAudio()
            return
        }
    }

    func performTitleShow () {
        
        titleLabel.layer.opacity = 0
        subtitleLabel.layer.opacity = 0
        
        [buttonBottonToView, buttonSmallerHeight].deactivate()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            self?.titleLabel.layer.opacity = 1
            self?.subtitleLabel.layer.opacity = 1

        })
    }
    
    func loadWord() {
        
        let url : URL! = URL(string: "https://www.merriam-webster.com/wotd/feed/rss2")
        let contents = try! String(contentsOf: url, encoding: String.Encoding.utf8)
        
        let XML : XMLDictionary! = getdictionaryFromXmlString(xmldata: contents)![0] as? XMLDictionary
        let data = (((XML["rss"]! as! XMLDictionary)["channel"]! as! XMLDictionary)["item"]! as! Array<XMLDictionary>) [0]
        
        guard let word = Word(data) else { print("Unable to parse word from XML"); return }
        
        self.word = word
    }
    
    func loadAudio () {
        
        guard let word = self.word else { return }
        
        loadingButton.progress = 0
        loadingButton.setNeedsDisplay()
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.tmergulhao.WordOfTheDay.download")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let downloadTask : URLSessionDownloadTask = session.downloadTask(with: word.audioURL)
        
        DispatchQueue.global(qos: .background).async {
            
            downloadTask.resume()
        }
    }
    
    override func viewDidLoad() {
        
        loadingButton.isEnabled = false

        loadWord()
        
        performTitleShow()
        
        performButtonMove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowGame" {
            
            guard let destination = segue.destination as? ViewController else { return }
            
            destination.word = word
            destination.audioURL = audioURL
        }
    }
}
