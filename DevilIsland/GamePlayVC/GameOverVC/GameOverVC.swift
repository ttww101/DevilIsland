//
//  GameOverVC.swift
//  DevilIsland
//
//  Created by Apple on 6/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GameOverVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    var goBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonClicked() {
        goBack?()
    }
}
