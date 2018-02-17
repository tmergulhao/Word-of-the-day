//
//  AudioPlayer.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import AVFoundation
import MediaPlayer

final class AudioPlayer : NSObject {
    
    // MARK : Singleton
    
    static let shared = AudioPlayer()
    
    private override init() {

        super.init()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setMode(AVAudioSessionModeDefault)
            try session.setActive(true)
        } catch let error as NSError {
            print("An error occurred setting the audio session \(error)")
        }
    }
    
    // MARK : Properties
    
    var player : AVAudioPlayer?
    
    // MARK : Methods
    
    func prepareToPlay (_ audioURL : URL) -> Bool {
        
        player = try? AVAudioPlayer(contentsOf: audioURL)

        return player != nil
    }
    
    func pause () { player?.pause() }
    
    func play () {

        player?.prepareToPlay()
        
        player?.volume = 1.0
        player?.play()
        
        guard let word = WordModel.first else { return }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: "\(word.title): \(word.shortDefinition)",
            MPMediaItemPropertyArtist: "Word of the day"
        ]
    }
}
