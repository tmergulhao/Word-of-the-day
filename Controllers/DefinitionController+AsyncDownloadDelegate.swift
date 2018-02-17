//
//  DefinitionController+AsyncDownloadDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 17/02/18.
//  Copyright © 2018 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension UIProgressView : Progressable {}

extension DefinitionController : AsyncDownloadDelegate {

    func loadAudio () {

        guard word.audioURL == nil else {

            print("There is audio!")

            playButton.isEnabled = true
            playButton.alpha = 1.0

            return
        }

        if progressView == nil {

            progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 5))

            view.addSubview(progressView!)
        }

        audioDownload = AsyncDownload()
        audioDownload?.progressable = progressView
        audioDownload?.delegate = self
        audioDownload?.load(word.externalAudioURL)
    }

    func download(_ manager : AsyncDownload, didCompleteWith error : Error?) {

        progressView?.removeFromSuperview()

        progressView = nil

        let alert = UIAlertController(
            title:"Shoot!",
            message:"There seems to be an issue in downloading the episode…",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    func download(_ manager : AsyncDownload, didFinishDownloadTo location : URL) {

        progressView?.removeFromSuperview()

        progressView = nil

        word.audioURL = location

        WordModel.update()

        AudioPlayer.shared.prepareToPlay(location)

        UIView.animate(withDuration: 1) {
            self.playButton.isEnabled = true
            self.playButton.alpha = 1.0
        }
    }
}
