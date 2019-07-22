//
//  GameBossVC.swift
//  DevilIsland
//
//  Created by Apple on 7/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GameBossVC: UIViewController {
    @IBOutlet weak var bossImg: UIImageView!
    
    var img: String!
    var timer: Timer?
    var imgAnitFinish: (() -> Void)?
    
    init(_ img: String) {
        super.init(nibName: "GameBossVC", bundle: nil)
        self.img = img
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bossImg.image = UIImage(named: img)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MusicEffect.shared.monster?.play()
        setAni()
        imgMove()
    }
    
    func setAni() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runReciprocal(_:)), userInfo: nil, repeats: true)
        
    }
    @objc func runReciprocal(_ timer: Timer) -> Void {
        bossImg.flipImage()
    }
    
    func imgMove() {
        UIView.animate(withDuration: 1, animations: {
            self.bossImg.center.y = -200
        }) { (finished) in
            if finished {
                self.timer?.invalidate()
                self.timer = nil
                self.imgMove2()
            }
        }
    }
    func imgMove2() {
        UIView.animate(withDuration: 1, animations: {
            self.bossImg.center.y = -200
        }) { (finished) in
            if finished {
                self.allFinished()
            }
        }
    }
    func allFinished() {
        imgAnitFinish?()
    }
}
