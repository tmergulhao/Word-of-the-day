//
//  IntroductionController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 13/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import Ambience

class IntroductionController : UIViewController {
    
    // MARK : UIView
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var buttonCenterY: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottonToView: NSLayoutConstraint!
    @IBOutlet weak var buttonSmallerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loadingButton: LoadingButton!
    @IBOutlet weak var historyButton : UIButton!
    
    func performAnimations () {
        
        loadingButton.isEnabled = false
        loadingButton.titleLabel?.text = nil
        
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        
        historyButton.alpha = 0
        historyButton.isEnabled = false
        
        [buttonBottonToView, buttonSmallerHeight].deactivate()
        view.layoutIfNeeded()
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: .allowUserInteraction, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4, animations: {
                self.titleLabel.alpha = 1
                self.subtitleLabel.alpha = 1
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                [self.buttonCenterY, self.buttonHeight].deactivate()
                [self.buttonBottonToView, self.buttonSmallerHeight].activate()

                self.view.layoutIfNeeded()
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                if WordModel.words.count > 1 {
                    self.historyButton.alpha = 1
                    self.historyButton.isEnabled = true
                } else {
                    self.historyButton.isEnabled = false
                }
            })

        }, completion: {
            completion in
            
            
        })
    }
    
    override func viewDidLoad() {
        
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            
            do {
                let model = WordModel.shared
                
                try model.loadWord()
                
                DispatchQueue.main.sync {
                    self?.didProgress(0)
                }
                
                model.loadAudio()
            } catch {
                
                DispatchQueue.main.sync {
                
                    let alert = UIAlertController(
                        title:"Shoot!",
                        message:"We could not find your word for today, what a bummer…",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        performAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Ambience.add(listener: self)
        
        WordModel.progressDelegate = self
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

// MARK: - Progress Delegate

extension IntroductionController : ProgressDelegate {
    
    func didComplete() {
        
        loadingLabel?.removeFromSuperview()
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

// MARK: - Ambience Listener

extension IntroductionController : AmbienceListener {
    
    @objc public func ambience(_ notification : Notification) {
        
        guard let currentState = notification.userInfo?["currentState"] as? AmbienceState else { return }
        
        ambienceState = currentState
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
