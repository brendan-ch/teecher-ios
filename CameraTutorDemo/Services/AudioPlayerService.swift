//
//  AudioPlayerService.swift
//  CameraTutorDemo
//
//  Created by Brendan Chen on 2025.10.25.
//

import Foundation
import AVFoundation

class AudioPlayerService: NSObject, AVAudioPlayerDelegate {
    private var player: AVAudioPlayer?
    
    func playAudio(_ data: Data) {
        do {
            player = try AVAudioPlayer(data: data)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
    }
}
