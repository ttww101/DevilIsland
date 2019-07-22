//
//  MusicEffect.swift
//  DevilIsland
//
//  Created by Apple on 7/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class MusicEffect: NSObject {
    static let shared = MusicEffect()
    var dice: AVAudioPlayer?
    var monster: AVAudioPlayer?
    var flip: AVAudioPlayer?
    var flipFail: AVAudioPlayer?
    var flipsuccess: AVAudioPlayer?
    var fail: AVAudioPlayer?
    var success: AVAudioPlayer?
    
    override init() {
        super.init()
        setAV()
    }
    func setAV() {
        do {
            let dicePath = Bundle.main.url(forResource: "dice", withExtension: "mp3")
            self.dice = try AVAudioPlayer(contentsOf: dicePath!, fileTypeHint: AVFileType.mp3.rawValue)
            
            let monsterPath = Bundle.main.url(forResource: "monster", withExtension: "wav")
            self.monster = try AVAudioPlayer(contentsOf: monsterPath!, fileTypeHint: AVFileType.wav.rawValue)
            
            let flipPath = Bundle.main.url(forResource: "flip", withExtension: "wav")
            self.flip = try AVAudioPlayer(contentsOf: flipPath!, fileTypeHint: AVFileType.wav.rawValue)
            
            let flipFailPath = Bundle.main.url(forResource: "flipfail", withExtension: "wav")
            self.flipFail = try AVAudioPlayer(contentsOf: flipFailPath!, fileTypeHint: AVFileType.wav.rawValue)
            
            let flipsuccessPath = Bundle.main.url(forResource: "flipsuccess", withExtension: "mp3")
            self.flipsuccess = try AVAudioPlayer(contentsOf: flipsuccessPath!, fileTypeHint: AVFileType.mp3.rawValue)
            
            let failPath = Bundle.main.url(forResource: "fail", withExtension: "wav")
            self.fail = try AVAudioPlayer(contentsOf: failPath!, fileTypeHint: AVFileType.wav.rawValue)
            
            let successPath = Bundle.main.url(forResource: "success", withExtension: "wav")
            self.success = try AVAudioPlayer(contentsOf: successPath!, fileTypeHint: AVFileType.wav.rawValue)
        } catch {
            print("error")
        }
    }
    func nilAV() {
        dice = nil
        monster = nil
        flip = nil
        flipFail = nil
        flipsuccess = nil
        fail = nil
        success = nil
    }
}
