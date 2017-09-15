//
//  IntroductionViewController+URLSessionDownloadDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 15/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import Foundation

extension IntroductionViewController : URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite > 0 {
            
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.sync {
                loadingButton.progress = progress
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        //try? FileManager.default.removeItem(at: location)
        
        DispatchQueue.main.sync {
            audioURL = location
            
            loadingButton.isEnabled = true
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {}
}
