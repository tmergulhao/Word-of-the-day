//
//  WordModel+URLSessionDownloadDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit

extension DefinitionController : URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    func loadAudio () {
        
        guard word.audioURL == nil else {
            playButton.isEnabled = true
            playButton.alpha = 1.0
            
            return
        }
        
        if progressView == nil {
            
            progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 5))
            
            view.addSubview(progressView!)
        }
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.tmergulhao.WordOfTheDay.download")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        downloadTask = session.downloadTask(with: word.externalAudioURL)
        
        downloadTask!.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite > 0 {
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.sync {
                
                progressView?.progress = progress
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        DispatchQueue.main.sync {
            
            word.audioURL = location
            
            progressView?.removeFromSuperview()
            
            progressView = nil
            
            AudioPlayer.shared.prepareToPlay(location)
            
            UIView.animate(withDuration: 1) {
                self.playButton.isEnabled = true
                self.playButton.alpha = 1.0
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error != nil {
            
            DispatchQueue.main.sync {
                
                progressView?.removeFromSuperview()
                
                progressView = nil
                
                let alert = UIAlertController(
                    title:"Shoot!",
                    message:"There seems to be an issue in downloading the episode…",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
