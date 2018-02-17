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
    
    @IBOutlet weak var buttonCenterY: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottonToView: NSLayoutConstraint!
    @IBOutlet weak var buttonSmallerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loadingButton: LoadingButton!
    @IBOutlet weak var historyButton : UIButton!
    
    override func viewDidLoad() {
        
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            
            do {
                
                try WordModel.shared.loadWord()
                
                if WordModel.words!.count > 1 {
                    
                    DispatchQueue.main.sync {
                        
                        self?.showHistoryButton()
                    }
                }
                
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
                
                self.loadingButton.layer.cornerRadius = 32
                
                self.view.layoutIfNeeded()
            })
        }, completion: {
            completion in
            
            self.loadingButton.isEnabled = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showHistoryButton () {
        
        UIView.animate(withDuration: 1) {
            
            self.historyButton.alpha = 1
            self.historyButton.isEnabled = true
        }
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return Ambience.currentState == .invert ? .lightContent : .default
    }
}

// MARK: - Ambience Listener

extension IntroductionController {
    
    override func ambience(_ notification: Notification) {
        
        super.ambience(notification)
        
        setNeedsStatusBarAppearanceUpdate()
    }
}
