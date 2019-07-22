//
//  GameScoreCell.swift
//  DevilIsland
//
//  Created by Apple on 6/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class GameScoreCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    var animat: Bool!
    var finishAni: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(_ type: GameScoreType, tint: String) {
        titleLabel.text = "\(type.title)\(tint)"
        
        if type == .total {
            let topLayer = CALayer()
            topLayer.backgroundColor = UIColor.gray.cgColor
            topLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
            self.layer.addSublayer(topLayer)
        }
    }
    
    func playScoreAnimat() {
//        if !animat {
//            let duration: Double = 0.5 //seconds
//            DispatchQueue.global().async {
//                for i in 0 ..< (self.score + 1) {
//                    let sleepTime = UInt32(duration/Double(self.score) * 1000000.0)
//                    usleep(sleepTime)
//                    DispatchQueue.main.async {
//                        self.scoreLabel.text = "\(i)"
//                    }
//                    if i == self.score {
//                        self.finishAni?()
//                    }
//                }
//            }
//        } else {
            self.scoreLabel.text = "\(self.score)"
//        }
    }
    
}
