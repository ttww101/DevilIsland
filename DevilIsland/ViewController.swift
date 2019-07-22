//
//  ViewController.swift
//  DevilIsland
//
//  Created by Apple on 6/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var backSound: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setSound()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backSound?.play()
        
    }
    func setSound() {
        do {
            let backSoundPath = Bundle.main.url(forResource: "homeback", withExtension: "mp3")
            self.backSound = try AVAudioPlayer(contentsOf: backSoundPath!, fileTypeHint: AVFileType.mp3.rawValue)
            self.backSound?.numberOfLoops = -1
        } catch {
            print("error")
        }
    }
    func nilSound() {
        backSound = nil
    }
    
    @IBAction func settingClick(_ sender: UIButton) {
        let settingVC = SettingVC()
        settingVC.cancelClo = {
            settingVC.remove()
        }
        settingVC.saveClo = {[weak self] (sound) in
            if sound {
                self?.setSound()
                self?.backSound?.play()
            } else {
                self?.nilSound()
            }
            settingVC.remove()
        }
        self.add(settingVC)
        settingVC.view.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    @IBAction func btnClick(_ sender: UIButton) {
        toGameMap()
    }
    func toGameMap() {
        backSound?.stop()
        self.present(GameMapVC(), animated: true, completion: nil)
    }

}

