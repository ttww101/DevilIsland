//
//  Card.swift
//  DevilIsland
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

struct CardModel {
    var image: String
}

struct Card {
    var image: String
    var isDrawed = false
    var unClick = false
    init(_ model: CardModel) {
        self.image = model.image
    }
    static func allImage() -> [String] {
        return ["card1.png", "card2.png", "card3.png", "card4.png", "card5.png", "card6.png", "card7.png", "card8.png", "card9.png", "card10.png"]
    }
}
