//
//  WordModel+URLSessionDownloadDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

extension WordModel : URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    func loadAudio () {
        
        guard let word = self.words.first else { return }
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.tmergulhao.WordOfTheDay.download")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let downloadTask : URLSessionDownloadTask = session.downloadTask(with: word.externalAudioURL)
        
        downloadTask.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite > 0 {
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.sync {
                progressDelegate?.didProgress(progress)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

        DispatchQueue.main.sync {
            
            var word = words.first
            
            if word != nil {
                word!.audioURL = location
                words[0] = word!
            }
            
            progressDelegate?.didComplete()
            
            AudioPlayer.shared.prepareToPlay()
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error != nil {
            DispatchQueue.main.sync {
                progressDelegate?.reachedError()
            }
        }
    }
}
