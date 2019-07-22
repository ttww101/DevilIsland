//
//  UIImage++.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension UIImageView {
    func flipImage() {
        let flipImageOrientation = (self.image!.imageOrientation.rawValue + 4) % 8
        let flipImage =  UIImage(cgImage:self.image!.cgImage!,
                                 scale:self.image!.scale,
                                 orientation:UIImage.Orientation(rawValue: flipImageOrientation)!
        )
        self.image = flipImage
    }
}
