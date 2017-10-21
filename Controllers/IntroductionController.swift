//
//  IntroductionController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 13/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

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
    
    func performButtonMove () {
        
        [buttonCenterY, buttonHeight].deactivate()
        [buttonBottonToView, buttonSmallerHeight].activate()
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            
            self?.view.layoutIfNeeded()
        })
    }

    func performTitleShow () {
        
        titleLabel.alpha = 0
        subtitleLabel.alpha = 0
        
        [buttonBottonToView, buttonSmallerHeight].deactivate()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            self?.titleLabel.alpha = 1
            self?.subtitleLabel.alpha = 1
        })
    }
    
    override func viewDidLoad() {
        
        loadingButton.isEnabled = false
        loadingButton.titleLabel?.text = nil
        
        WordModel.progressDelegate = self
        
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
        
        performTitleShow()
        performButtonMove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}

extension IntroductionController : ProgressDelegate {
    
    func didComplete() {
        
        loadingLabel.removeFromSuperview()
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
