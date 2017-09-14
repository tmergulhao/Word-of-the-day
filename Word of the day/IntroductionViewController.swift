//
//  IntroductionViewController.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 13/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

class IntroductionViewController : UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var buttonCenterY: NSLayoutConstraint!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buttonBottonToView: NSLayoutConstraint!
    @IBOutlet weak var buttonSmallerHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {

        titleLabel.layer.opacity = 0
        subtitleLabel.layer.opacity = 0
        
        [buttonBottonToView, buttonSmallerHeight].deactivate()
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
            [weak self]() -> Void in
            self?.titleLabel.layer.opacity = 1
            self?.subtitleLabel.layer.opacity = 1
        }) { (completion) in
            return
        }
        
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
            
        }) { (completion) in
            return
        }
    }
}
