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
        
        titleLabel.layer.opacity = 0
        subtitleLabel.layer.opacity = 0
        
        [buttonBottonToView, buttonSmallerHeight].deactivate()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            self?.titleLabel.layer.opacity = 1
            self?.subtitleLabel.layer.opacity = 1
        })
    }
    
    override func viewDidLoad() {
        
        loadingButton.isEnabled = false
        
        WordModel.progressDisplay = loadingButton
        WordModel.loadWord()
        
        performTitleShow()
        performButtonMove()
    }
}
