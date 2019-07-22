//
//  GameData.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LeanCloud

@objcMembers class GameData: NSObject {
    static let shared = GameData()
    let userDefault = UserDefaults.standard
    dynamic var score = 0
    dynamic var rank = 0
    var star = 5
    var objectId = ""
    var notification = true
    var music = true
    var effect = true
    var position = 0
    
    override init() {
        super.init()
        if let objectId = self.userDefault.string(forKey: "objectId") {
            self.objectId = objectId
        }
        position = self.userDefault.integer(forKey: "position")
        score = self.userDefault.integer(forKey: "score")
        if let playDate = self.userDefault.string(forKey: "playDate") {
            if playDate == Date().getConvert() {
                star = self.userDefault.integer(forKey: "star")
            }
        }
        if self.userDefault.bool(forKey: "settingChange") {
            notification = self.userDefault.bool(forKey: "notification")
            music = self.userDefault.bool(forKey: "music")
            effect = self.userDefault.bool(forKey: "effect")
        }
        if objectId != "" {
            getRank()
        }
    }
    
    func saveObjectId() {
        self.userDefault.set(objectId, forKey: "objectId")
        self.userDefault.synchronize()
    }
    func savePosition() {
        self.userDefault.set(position, forKey: "position")
        self.userDefault.synchronize()
    }
    func saveScore() {
        self.userDefault.set(score, forKey: "score")
        self.userDefault.synchronize()
        if objectId != "" {
            getRank()
        }
    }
    func saveStar() {
        self.userDefault.set(Date().getConvert(), forKey: "playDate")
        self.userDefault.set(star, forKey: "star")
        self.userDefault.synchronize()
    }
    func saveNotification() {
        self.userDefault.set(true, forKey: "settingChange")
        self.userDefault.set(notification, forKey: "notification")
        self.userDefault.synchronize()
    }
    func saveMusic() {
        self.userDefault.set(music, forKey: "music")
        self.userDefault.synchronize()
    }
    func saveEffect() {
        self.userDefault.set(effect, forKey: "effect")
        self.userDefault.synchronize()
    }
    func getRank() {
        if objectId != "" {
            let cql = "select count(*) from userscore where score>=\(score)"
            
            _ = LCCQLClient.execute(cql) { result in
                switch result {
                case .success(let result):
                    self.rank = result.count
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
