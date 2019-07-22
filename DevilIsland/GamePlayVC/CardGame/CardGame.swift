//
//  CardGame.swift
//  DevilIsland
//
//  Created by Apple on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import GameplayKit

enum GameMode {
    // 低、中、高、燈籠魚、章魚、河豚、骷髏頭
    case low, median, high, lantern, octopus, puffer, shantou
    // change times
    var magic: Int {
        switch self {
        case .low:
            return 1
        case .median:
            return 2
        case .high:
            return 3
        case .lantern:
            return 3
        case .octopus:
            return 0
        case .puffer:
            return 3
        case .shantou:
            return 0
        }
    }
    // per magic cast time
    var changeTime: Int {
        switch self {
        case .low:
            return Int(arc4random_uniform(7)+24)
        case .median:
            return Int(arc4random_uniform(7)+14)
        case .high:
            return Int(arc4random_uniform(7)+4)
        case .octopus:
            return 4
        case .lantern, .puffer, .shantou:
            return 5
        }
    }
    // filp times
    var step: Int {
        switch self {
        case .low:
            return Int(arc4random_uniform(5)+36)
        case .median:
            return Int(arc4random_uniform(5)+26)
        case .high:
            return Int(arc4random_uniform(5)+16)
        case .lantern, .octopus, .puffer, .shantou:
            return 30
        }
    }
    
    var basicScore: Int {
        switch self {
        case .low:
            return 500
        case .median:
            return 1500
        case .high:
            return 2500
        case .lantern, .octopus, .puffer, .shantou:
            return 3500
        }
    }
    
    var bossImg: String {
        switch self {
        case .low, .median, .high:
            return ""
        case .lantern:
            return "monster02"
        case .octopus:
            return "monster04"
        case .puffer:
            return "monster03"
        case .shantou:
            return "monster05"
        }
    }
}

struct CardGame {
    var gameCards = [Card]()
    var gameItems = [Int]()
    var gameSpecial = [Int]()
    var gamePosition = [Int]()
    var changeTime: Int!
    var magic: Int!
    var step: Int!
    var cardSet: CardSet
    var count: Int
    var mode: GameMode
    
    init(_ count: Int, _ mode: GameMode) {
        self.cardSet = CardSet(Int(count/2))
        self.count = count
        self.mode = mode
        modeSet()
    }
    
    mutating func modeSet() {
        self.changeTime = mode.changeTime
        self.magic = mode.magic
        self.step = mode.step
    }
    
    mutating func start() {
        gameCards.removeAll()
        gameItems.removeAll()
        var cards = cardSet.cards
        
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: count - 1)
        for i in 0..<count {
            let index  = shuffledDistribution.nextInt()
            let card = cards[index]
            gameCards.append(card)
            gameItems.append(i)
            gamePosition.append(i)
        }
    }
    
    mutating func transfer(_ time: Int) -> Bool {
        var b = false
        
        if (time % self.changeTime) == 0 { b = true }
        if self.mode == .octopus {
            if gameItems.count < 4 { b = false }
        } else {
            if gameItems.count < 3 { b = false }
            if magic == 0 { b = false }
        }
        return b
    }
    
    mutating func matchCards(_ first: Int) {
        if let idx = gameItems.firstIndex(of: first) {
            gameItems.remove(at: idx)
        }
    }
    
    mutating func positinTransfer(_ one: Int, _ two: Int) {
        self.gamePosition.swapAt(one, two)
    }
    
    mutating func getIntTransfer() -> (Int, Int) {
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: gameItems.count - 1)
        let s = (gameItems[shuffledDistribution.nextInt()], gameItems[shuffledDistribution.nextInt()])
        return s
    }
    
    // MARK: - Octopus
    mutating func getOctopusTransfer() -> [Int] {
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: gameItems.count - 1)
        var intA = [Int]()
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        return intA
    }
    
    // MARK: - Puffer
    mutating func getPufferTransfer() -> [Int] {
        let shuffledDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: gameItems.count - 1)
        var intA = [Int]()
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        intA.append(gameItems[shuffledDistribution.nextInt()])
        for i in 0..<intA.count {
            matchCards(intA[i])
        }
        return intA
    }
    
    mutating func getCardBeside(_ cardNum: Int) -> [Int] {
        var position = [Int]()
        if let idx = gamePosition.firstIndex(of: cardNum) {
            if idx > 2 {
                position.append(gamePosition[idx - 3])
            }
            if idx < (count - 3) {
                position.append(gamePosition[idx + 3])
            }
            switch (idx % 3) {
            case 0:
                position.append(gamePosition[idx + 1])
            case 1:
                position.append(gamePosition[idx - 1])
                position.append(gamePosition[idx + 1])
            case 2:
                position.append(gamePosition[idx - 1])
            default:
                return position
            }
        }
        return position
    }
    
    mutating func addItem(_ cardNum: Int) {
        if !gameCards[cardNum].isDrawed {
            if let idx = gameItems.firstIndex(of: cardNum) {
                
            } else {
                gameItems.append(cardNum)
            }
        }
    }
    
    // MARK: - game special
    mutating func setGameSpecial() {
        gameSpecial.append(0)
    }
    mutating func uploadGameSpecial() {
        if let _ = gameSpecial.last {
            gameSpecial[gameSpecial.count - 1] += 1
        } else {
            gameSpecial.append(1)
        }
    }
    mutating func getLastGameSpecial() -> Int? {
        if let last = gameSpecial.last {
            return last
        }
        return nil
    }
}
