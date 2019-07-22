//
//  Int++.swift
//  DevilIsland
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension Int {
    func toTimeString() -> String {
        var value = ""
        if Int(self / 3600) < 10 {
            value = "0\(Int(self / 3600))"
        } else {
            value = "\(Int(self / 3600))"
        }
        value += ":"
        let m = self - (Int(self / 3600) * 3600)
        if Int(m / 60) < 10 {
            value += "0\(Int(m / 60))"
        } else {
            value += "\(Int(m / 60))"
        }
        value += ":"
        let s = m - (Int(m / 60) * 60)
        if s < 10 {
            value += "0\(s)"
        } else {
            value += "\(s)"
        }
        return value
    }
}
