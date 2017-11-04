//
//  DefinitionController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import SafariServices
import Ambience

class DefinitionController : UITableViewController {
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var shortDefinitionLabel: UILabel!
    @IBOutlet weak var fullDefinitionLabel: UILabel!
    
    var word : Word?
    
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
    
    @IBAction func backButtonPressed (_ sender : UIButton) {
        
        playing = false
        
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: false)
        }
    }
    
    var playing : Bool = false {
        didSet {
            if playing {
                AudioPlayer.shared.play()
            } else {
                AudioPlayer.shared.pause()
            }
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if let someWord = word {
            wordLabel.text = someWord.title
            wordLabel.setCharactersSpacing(5)
            shortDefinitionLabel.text = someWord.shortDefinition
            fullDefinitionLabel.attributedText = NSAttributedString(htmlString: someWord.definition)
        }
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didInterrupt(_ :)), name: Notification.Name.AVAudioSessionInterruption, object: self)
        
        Ambience.add(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Ambience.remove(listener: self)
    }
    
    var ambienceState : AmbienceState = .Regular
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return ambienceState == .Invert ? .lightContent : .default
    }
    
    @objc func didInterrupt (_ notification : Notification) {
        print("interruption received: \(notification)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        NotificationCenter.default.removeObserver(self)
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Ambience Listener

extension DefinitionController : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        ambienceState = currentState
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
