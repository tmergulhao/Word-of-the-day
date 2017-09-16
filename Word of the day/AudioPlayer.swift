//
//  AudioPlayer.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 16/09/2017.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import AVFoundation

final class AudioPlayer : NSObject {
    
    // MARK : Singleton
    
    static let shared = AudioPlayer()
    
    private override init() {}
    
    // MARK : Properties
    
    var player : AVAudioPlayer?
    
    var audioURL : URL? {
        didSet {
            guard let url = audioURL else { return }
            
            player = try? AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
        }
    }
    
    func play () {
        player?.volume = 1.0
        player?.play()
    }
}
