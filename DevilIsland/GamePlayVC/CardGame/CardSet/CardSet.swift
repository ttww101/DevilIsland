//
//  CardSet.swift
//  DevilIsland
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GameplayKit  

struct CardSet {
    var cards = [Card]()
    
    init(_ count: Int) {
        let allImage = Card.allImage()
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: count - 1)
        
        for _ in 0...count - 1 {
            let index  = shuffledDistribution.nextInt()
            let card = Card(CardModel(image: allImage[index]))
//            let sameCard = Card(CardModel(image: allImage[index]))
            cards.append(card)
            cards.append(card)
        }
    }
}
