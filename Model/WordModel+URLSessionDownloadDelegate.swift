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
        
        guard let word = self.word else { return }
        
        progressDisplay?.progress = 0
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.tmergulhao.WordOfTheDay.download")
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        
        let downloadTask : URLSessionDownloadTask = session.downloadTask(with: word.audioURL)
        
        DispatchQueue.global(qos: .background).async {
            
            print("Did start downloading audio file")
            
            downloadTask.resume()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite > 0 {
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.sync {
                progressDisplay?.progress = progress
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //try? FileManager.default.removeItem(at: location)

        DispatchQueue.main.sync {
            
            print("Did finish downloading audio file")
            
            AudioPlayer.shared.audioURL = location
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {}
}
