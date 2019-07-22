//
//  DiceView.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit

class DiceView: UIView {
    
    var diceNum: ((Int) -> Void)?
    var noStar: (() -> Void)?
    var click = true
    
    private var dice = 1
    private var timer: Timer?
    
    private var diceBG: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "map_box")
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
    }()
    
    private var diceImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "dice1")
        img.animationImages = [UIImage(named: "shaking1")
                              ,UIImage(named: "shaking4")
                              ,UIImage(named: "shaking6")
                              ,UIImage(named: "shaking2")
                              ,UIImage(named: "shaking5")
                              ,UIImage(named: "shaking3")] as? [UIImage]
        img.animationDuration = 0.1
        img.animationRepeatCount = 10
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .clear
        setBG()
        setDice()
        setGesture()
    }
    private func setBG() {
        self.addSubview(diceBG)
        diceBG.snp.makeConstraints { (maker) in
            maker.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    private func setDice() {
        self.addSubview(diceImg)
        diceImg.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(self.frame.size.width * (3/5))
            maker.center.equalToSuperview()
        }
    }
    private func setGesture() {
        let onTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        self.addGestureRecognizer(onTap)
    }
    
    @objc private func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if GameData.shared.star == 0 {
            noStar?()
            return
        }
        if click {
            GameData.shared.star -= 1
            GameData.shared.saveStar()
            MusicEffect.shared.dice?.play()
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runDice(_:)), userInfo: nil, repeats: true)
            diceImg.startAnimating()
            dice = Int(arc4random_uniform(6)+1)
//            dice = 6
            diceImg.image = UIImage(named: "dice\(dice)")
            click = false
        }
    }
    @objc private func runDice(_ timer: Timer) -> Void {
        self.timer?.invalidate()
        self.timer = nil
        print(dice)
        diceNum?(dice)
    }
}
