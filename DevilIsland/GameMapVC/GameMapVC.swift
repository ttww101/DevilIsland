//
//  GameMapVC.swift
//  DevilIsland
//
//  Created by Apple on 6/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class GameMapVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var gameScrollView: UIScrollView!
    @IBOutlet weak var gameMapView: UIView!
    @IBOutlet weak var gamePoint1: UIImageView!
    @IBOutlet weak var gamePoint2: UIImageView!
    @IBOutlet weak var gamePoint3: UIImageView!
    @IBOutlet weak var gamePoint4: UIImageView!
    @IBOutlet weak var gamePoint5: UIImageView!
    @IBOutlet weak var gamePoint6: UIImageView!
    @IBOutlet weak var gamePoint7: UIImageView!
    @IBOutlet weak var gamePoint8: UIImageView!
    @IBOutlet weak var gamePoint9: UIImageView!
    @IBOutlet weak var gamePoint10: UIImageView!
    @IBOutlet weak var gamePoint11: UIImageView!
    @IBOutlet weak var gamePoint12: UIImageView!
    @IBOutlet weak var gamePoint13: UIImageView!
    @IBOutlet weak var gamePoint14: UIImageView!
    @IBOutlet weak var gamePoint15: UIImageView!
    @IBOutlet weak var gamePoint16: UIImageView!
    @IBOutlet weak var gamePoint17: UIImageView!
    @IBOutlet weak var gamePoint18: UIImageView!
    @IBOutlet weak var gamePoint19: UIImageView!
    @IBOutlet weak var gamePoint20: UIImageView!
    @IBOutlet weak var gamePoint21: UIImageView!
    @IBOutlet weak var gamePoint22: UIImageView!
    @IBOutlet weak var gamePoint23: UIImageView!
    @IBOutlet weak var gamePoint24: UIImageView!
    @IBOutlet weak var gamePoint25: UIImageView!
    @IBOutlet weak var diceView: DiceView!
    @IBOutlet weak var userView: UserView!
    @IBOutlet weak var rankView: RankView!
    
    var gamePointArray = [UIImageView]()
    
    var playerImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "map_people")
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
    }()
    
    var backSound: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameScrollView.minimumZoomScale = 1.0
        gameScrollView.maximumZoomScale = 5.0
        
        setSound()
        setPointArray()
        setPlayer()
        setDiceView()
        setRankView()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backSound?.play()
    }
    
    // MARK: - Sound
    func setSound() {
        do {
            let backSoundPath = Bundle.main.url(forResource: "mapback", withExtension: "wav")
            self.backSound = try AVAudioPlayer(contentsOf: backSoundPath!, fileTypeHint: AVFileType.wav.rawValue)
            self.backSound?.numberOfLoops = -1
        } catch {
            print("error")
        }
    }
    func nilSound() {
        backSound = nil
    }
    
    // MARK: - UI
    func setPointArray() {
        for view in gameMapView.subviews {
            if view is UIImageView, view.tag != 0 {
                gamePointArray.append(view as! UIImageView)
            }
        }
        gamePointArray.sort { (image1, image2) -> Bool in
            return image1.tag < image2.tag
        }
    }
    func setPlayer() {
        self.gameMapView.addSubview(playerImg)
        playerImg.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.gameMapView.frame.size.width * (84/2208))
            maker.height.equalTo(self.gameMapView.frame.size.height * (250/1242))
            maker.center.equalTo(self.gamePointArray[GameData.shared.position])
        }
    }
    func setDiceView() {
        diceView.diceNum = { [weak self] (dice) in
            guard let self = self else { return }
            self.userView.updateStar()
            self.goal = dice
            self.moves = 0
            self.playerMove()
        }
        diceView.noStar = {[weak self] in
            self?.setBuyStarVC()
        }
    }
    func setBuyStarVC() {
        let buyStarVC = BuyStarVC()
        buyStarVC.buySuccess = {[weak self] in
            self?.userView.updateStar()
        }
        self.add(buyStarVC)
        buyStarVC.view.snp.makeConstraints { (maker) in
            maker.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    func setRankView() {
        rankView.viewTap = { [weak self] in
            guard let self = self else { return }
            self.showRankVC()
        }
    }
    func showRankVC() {
        let rankVC = RankVC()
//        rankVC.closeView = {
//            rankVC.remove()
//        }
        self.add(rankVC)
        rankVC.view.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - scroll view delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.gameMapView
    }
    
    // MARK: - player move
    var goal = 0
    var moves = 0
    var orientation = true
    func playerMove() {
        GameData.shared.position = (GameData.shared.position == 24) ? 0 : GameData.shared.position + 1
        var moveOri = true
        if (playerImg.center.x - gamePointArray[GameData.shared.position].center.x) > 0 {
            moveOri = false
        }
        if orientation != moveOri {
            playerImg.flipImage()
            orientation = moveOri
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.playerImg.center = self.gamePointArray[GameData.shared.position].center
        }) {[weak self] (completion) in
            guard let self = self else { return }
            if completion {
                self.moves += 1
                if self.moves < self.goal {
                    self.playerMove()
                } else {
                    self.diceView.click = true
                    GameData.shared.savePosition()
                    self.showLevelVC()
                }
            }
        }
    }
    
    // MARK: - LevelVC
    func showLevelVC() {
        switch GameData.shared.position {
        case 6:
            self.goGameView(GameModel(x: 6, y: 3, mode: .lantern))
        case 13:
            self.goGameView(GameModel(x: 6, y: 3, mode: .octopus))
        case 8:
            self.goGameView(GameModel(x: 6, y: 3, mode: .puffer))
        case 21:
            self.goGameView(GameModel(x: 6, y: 3, mode: .shantou))
        default:
            let levelVC = LevelVC()
            levelVC.closeClosure = {
                levelVC.remove()
            }
            levelVC.gameClosure = { [weak self] (gameMode) in
                levelVC.remove()
                self?.goGameView(GameModel(x: 4, y: 3, mode: gameMode))
            }
            self.add(levelVC)
            levelVC.view.snp.makeConstraints { (maker) in
                maker.top.bottom.leading.trailing.equalToSuperview()
            }
        }
    }
    
    // MARK: - GamePlayVC
    func goGameView(_ gameModel: GameModel) {
        backSound?.stop()
        let gamePlayVC = GamePlayVC(gameModel)
        self.present(gamePlayVC, animated: true, completion: nil)
    }
    
    // MARK: - GameBack
    @IBAction func backBtnClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
