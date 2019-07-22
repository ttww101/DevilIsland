//
//  UIButton++.swift
//  DevilIsland
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension UIButton {
    func reset() {
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.setBackgroundImage(UIImage(named: "cardback"), for: .normal)
            self.setImage(nil, for: .normal)
            self.backgroundColor = .clear
        }, completion: nil)
    }
}
