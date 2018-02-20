//
//  AudioDownload.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 17/02/18.
//  Copyright © 2018 Tiago Mergulhão. All rights reserved.
//

import Foundation

@objc protocol AsyncDownloadDelegate : class {
    @objc optional func download(_ manager : AsyncDownload, didUpdateDownload progress : Float)
    @objc optional func download(_ manager : AsyncDownload, didCompleteWith error : Error?)
    @objc optional func download(_ manager : AsyncDownload, didFinishDownloadTo location : URL)
}

protocol Progressable : class {
    var progress : Float { get set }
}

class AsyncDownload : NSObject {

    weak var progressable : Progressable?

    var downloadTask : URLSessionDownloadTask?
    weak var delegate : AsyncDownloadDelegate?

    var session : URLSession?
}

extension AsyncDownload : URLSessionTaskDelegate, URLSessionDownloadDelegate {

    func load(_ url : URL) {
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.tmergulhao.WordOfTheDay.download")

        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        downloadTask = session!.downloadTask(with: url)
        downloadTask!.resume()
    }

    func cancel () {
        downloadTask?.cancel()
        session?.finishTasksAndInvalidate()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            DispatchQueue.main.sync {
                progressable?.progress = progress
                delegate?.download?(self, didUpdateDownload: progress)
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.sync {
            delegate?.download?(self, didFinishDownloadTo: location)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            DispatchQueue.main.sync {
                delegate?.download?(self, didCompleteWith: error)
            }
        }
    }
}
