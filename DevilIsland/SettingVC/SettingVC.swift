//
//  SettingVC.swift
//  DevilIsland
//
//  Created by Apple on 7/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    @IBOutlet weak var musicView: UIView!
    @IBOutlet weak var musicBack: UIImageView!
    @IBOutlet weak var musicon: UIImageView!
    @IBOutlet weak var musicoff: UIImageView!
    
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var effectback: UIImageView!
    @IBOutlet weak var effecton: UIImageView!
    @IBOutlet weak var effectoff: UIImageView!
    
    @IBOutlet weak var notificationBtn: UIButton!
    
    var notification = true
    var music = true
    var effect = true
    
    var cancelClo: (() -> Void)?
    var saveClo: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notification = GameData.shared.notification
        music = GameData.shared.music
        effect = GameData.shared.effect
        
        let musicTap = UITapGestureRecognizer(target: self, action: #selector(musicTapped(tapGestureRecognizer:)))
        self.musicView.addGestureRecognizer(musicTap)
        
        let effectTap = UITapGestureRecognizer(target: self, action: #selector(effectTapped(tapGestureRecognizer:)))
        self.effectView.addGestureRecognizer(effectTap)
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        if !notification {
            notificationBtn.setImage(UIImage(named: "cbox01"), for: .normal)
        }
        if !music {
            musicBack.image = UIImage(named: "set_g")
            musicon.isHidden = true
            musicoff.isHidden = false
        }
        if !effect {
            effectback.image = UIImage(named: "set_g")
            effecton.isHidden = true
            effectoff.isHidden = false
        }
    }
    
    @objc private func musicTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        music = !music
        if music {
            musicBack.image = UIImage(named: "set_g1")
            musicon.isHidden = false
            musicoff.isHidden = true
        } else {
            musicBack.image = UIImage(named: "set_g")
            musicon.isHidden = true
            musicoff.isHidden = false
        }
    }
    @objc private func effectTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        effect = !effect
        if effect {
            effectback.image = UIImage(named: "set_g1")
            effecton.isHidden = false
            effectoff.isHidden = true
        } else {
            effectback.image = UIImage(named: "set_g")
            effecton.isHidden = true
            effectoff.isHidden = false
        }
    }
    
    @IBAction func notificationSetting(_ sender: UIButton) {
        notification = !notification
        if notification {
            notificationBtn.setImage(UIImage(named: "cbox02"), for: .normal)
        } else {
            notificationBtn.setImage(UIImage(named: "cbox01"), for: .normal)
        }
    }
    @IBAction func cancelClick(_ sender: UIButton) {
        cancelClo?()
    }
    @IBAction func saveClick(_ sender: UIButton) {
        GameData.shared.notification = notification
        GameData.shared.saveNotification()
        GameData.shared.music = music
        GameData.shared.saveMusic()
        GameData.shared.effect = effect
        GameData.shared.saveEffect()
        if effect {
            MusicEffect.shared.setAV()
        } else {
            MusicEffect.shared.nilAV()
        }
        saveClo?(music)
    }
    
}
