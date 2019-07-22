//
//  LevelVC.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class LevelVC: UIViewController {
    
    var closeClosure: (() -> Void)?
    var gameClosure: ((GameMode) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeBtnClick(_ sender: UIButton) {
        closeClosure?()
    }
    @IBAction func gameBtnClick(_ sender: UIButton) {
        var mode: GameMode = .low
        switch sender.tag {
        case 0:
            mode = .low
        case 1:
            mode = .median
        case 2:
            mode = .high
        default:
            mode = .low
        }
        gameClosure?(mode)
    }
}
