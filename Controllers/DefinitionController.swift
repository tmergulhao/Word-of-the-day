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
    @IBOutlet weak var fullDefinitionLabel: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func viewPodcast(_ sender: UIButton) {
        
        let url : URL! = URL(string: "https://itunes.apple.com/us/podcast/merriam-websters-word-of-the-day/id164829166")
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func viewOnWebsite(_ sender: UIButton) {
        
        let url : URL! = URL(string: WordModel.words.first!.link)
        let safari = SFSafariViewController(url: url)
        
        safari.preferredControlTintColor = StyleKit.color.tint
        present(safari, animated: true, completion: nil)
    }
    
    @IBAction func playPause(_ sender: UIButton) {
        
        playing = !playing
        
        (sender as? PlayButton)?.switchOnOffState()
    }
    
    @IBAction func lookUp(_ sender: UIButton) {
        
        guard let word = WordModel.words.first else { return }
        
        let reference = UIReferenceLibraryViewController(term: word.title)
        
        present(reference, animated: true, completion: nil)
    }
    
    var word : WordStruct!
    
    var playing : Bool = false {
        didSet {
            if playing {
                AudioPlayer.shared.play()
            } else {
                AudioPlayer.shared.pause()
            }
        }
    }
    
    var progressView : UIProgressView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        playButton.isEnabled = false
        playButton.alpha = 0.3
        
        loadAudio()
        
        tableView.rowHeight = 140
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        if let word = word {
            
            wordLabel.text = word.title
            wordLabel.setCharactersSpacing(5)
            
            shortDefinitionLabel.text = word.shortDefinition
            shortDefinitionLabel.sizeToFit()
            
            fullDefinitionLabel.attributedText = NSAttributedString(htmlString: word.definition.styleWrapped)
            
            UIView.setAnimationsEnabled(false)
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    @objc func didInterrupt (_ notification : Notification) {
        
        print("interruption received: \(notification)")
    }
    
    override func viewWillAppear (_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didInterrupt(_ :)), name: Notification.Name.AVAudioSessionInterruption, object: self)
    }
    
    var downloadTask : URLSessionDownloadTask?
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        NotificationCenter.default.removeObserver(self)
        
        downloadTask?.cancel()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        let audio = AudioPlayer.shared
        
        guard let e = event, let player = audio.player else { return }
        
        if e.type == .remoteControl {
            switch e.subtype {
            case .remoteControlTogglePlayPause:
                if player.rate > 0.0 {
                    audio.pause()
                } else {
                    audio.play()
                }
            case .remoteControlPlay:
                audio.play()
            case .remoteControlPause:
                audio.pause()
            default:
                print("received sub type \(e.subtype) Ignoring")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        return nil
    }
}
