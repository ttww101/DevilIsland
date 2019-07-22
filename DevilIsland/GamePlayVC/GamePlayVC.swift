//
//  GamePlayVC.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit

struct GameModel {
    var x: Int
    var y: Int
    var mode: GameMode
}

class GamePlayVC: UIViewController {
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var subMainView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var specialView: UIView!
    @IBOutlet weak var specialNumImg: UIImageView!
    @IBOutlet weak var GameView: UIView!
    @IBOutlet weak var readyView: UIView!
    @IBOutlet weak var readyImg: UIImageView!
    
    var steps = 0 {
        didSet {
            stepLabel.text = "步数\n\(steps)"
            stepLabel.adjustsFontSizeToFitWidth = true
        }
    }
    var time = 0 {
        didSet {
            timeLabel.text = "時間\n\(time.toTimeString())"
            timeLabel.adjustsFontSizeToFitWidth = true
        }
    }
    var ready = 5 {
        didSet {
            readyImg.image = UIImage(named: "wp\(ready)")
        }
    }
    
    var gameModel: GameModel!
    var cardGame: CardGame!
    var cardBtns = [UIButton]()
    var timer: Timer!
    
    init(_ model: GameModel) {
        super.init(nibName: nil, bundle: nil)
        self.gameModel = model
        self.cardGame = CardGame((model.x * model.y), model.mode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameBoss()
    }
    
    var firstLoad = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstLoad {
            GameView.layoutIfNeeded()
            setUI()
            firstLoad = !firstLoad
        }
    }
    func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gameBoss() {
        if cardGame.mode.bossImg != "" {
            let gameBossVC = GameBossVC(cardGame.mode.bossImg)
            gameBossVC.imgAnitFinish = {[weak self] in
                gameBossVC.remove()
                self?.gameRest()
            }
            self.add(gameBossVC)
            gameBossVC.view.snp.makeConstraints { (maker) in
                maker.top.bottom.leading.trailing.equalToSuperview()
            }
        } else {
            gameRest()
        }
    }
    
    
    // MARK: - UI
    func setUI() {
        setCardBtn()
    }
    func setCardBtn() {
        let xspace: CGFloat = 5
        let yspace: CGFloat = 5
        let cardwidth = (GameView.frame.size.width - (7 * xspace)) / 6
        let cardheight = (GameView.frame.size.height - (4 * yspace)) / 3
        let xbasic: CGFloat = (gameModel.x == 6) ? 5 : (5 * 2) + cardwidth
        for i in 0..<cardGame.count {
            let x = CGFloat(Int(i / 3))
            let y = CGFloat(i % 3)
            let button = UIButton(frame: CGRect(x: xbasic + (x * cardwidth) + (x * xspace), y: yspace + (y * cardheight) + (y * yspace), width: cardwidth, height: cardheight))
            button.setBackgroundImage(UIImage(named: "cardback"), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(CardBtnPressed(_:)), for: .touchUpInside)
            cardBtns.append(button)
            GameView.addSubview(button)
        }
    }
    
    // MARK: - Game
    func gameRest() {
        steps = cardGame.step
        time = 0
        btnBool = true
        timeBool = false
        cardGame.start()
        registerReciprocal()
        resetCard()
    }
    func gameReadyPlay() {
        releaseTimer()
        readyView.isHidden = true
        registerGameTime()
    }
    func resetCard() {
        for i in 0..<cardBtns.count {
            cardBtns[i].reset()
        }
    }
    func gameSpecial() {
        if let special = cardGame.getLastGameSpecial() {
            if special != 0 {
                specialNumImg.image = UIImage(named: "wp\(special)")
                specialView.isHidden = false
            } else {
                specialView.isHidden = true
            }
        }
    }
    
    // MARK: - Game Effect
    var effectTime = 0
    func GameCardChange() {
        let item = cardGame.getIntTransfer()
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let self = self else { return }
            let center1 = self.cardBtns[item.0].center
            let center2 = self.cardBtns[item.1].center
            self.cardBtns[item.0].center = center2
            self.cardBtns[item.1].center = center1
        }) {[weak self] (completion) in
            guard let self = self else { return }
            guard completion else { return }
            self.cardGame.positinTransfer(item.0, item.1)
            self.effectTime += 1
            if self.effectTime == self.cardGame.magic {
                self.registerGameTime()
                self.timeBool = false
            } else {
                self.GameCardChange()
            }
        }
    }
    func MultiGameCardChange() {
        let item = cardGame.getOctopusTransfer()
        var itemPosition = [CGPoint]()
//        for i in 0..<item.count {
//            itemPosition.append(cardBtns[item[i]].frame.origin)
//            cardBtns[item[i]].setImage(UIImage(named: "foot"), for: .normal)
//        }
        UIView.animate(withDuration: 1, delay: 0, options: .transitionFlipFromLeft, animations: {[weak self] in
            for i in 0..<item.count {
                itemPosition.append(self?.cardBtns[item[i]].frame.origin ?? .zero)
                self?.cardBtns[item[i]].setImage(UIImage(named: "foot"), for: .normal)
            }
        }) {[weak self] (completion) in
            UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromLeft, animations: {[weak self] in
                guard let self = self else { return }
                for i in 0..<item.count {
                    self.cardBtns[item[i]].alpha = 0.01
                }
            }) {[weak self] (completion) in
                guard let self = self else { return }
                guard completion else { return }
                for i in 0..<item.count {
                    let j = ((i + 2) > (item.count - 1)) ? (i + 2) - item.count : (i + 2)
                    self.cardBtns[item[i]].frame.origin = itemPosition[j]
                }
                self.MultiGameCardChange2(item)
            }
        }
//        UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromLeft, animations: {[weak self] in
//            guard let self = self else { return }
//            for i in 0..<item.count {
//                self.cardBtns[item[i]].frame.size = .zero
//            }
//        }) {[weak self] (completion) in
//            guard let self = self else { return }
//            guard completion else { return }
//            for i in 0..<item.count {
//                let j = ((i + 2) > (item.count - 1)) ? (i + 2) - item.count : (i + 2)
//                self.cardBtns[item[i]].frame.origin = itemPosition[j]
//            }
//            self.MultiGameCardChange2(item, itemSize)
//        }
//        UIView.animate(withDuration: 1, animations: {[weak self] in
//            guard let self = self else { return }
//            for i in 0..<item.count {
//                self.cardBtns[item[i]].frame.size = .zero
//            }
//        }) {[weak self] (completion) in
//            guard let self = self else { return }
//            guard completion else { return }
//            for i in 0..<item.count {
//                let j = ((i + 2) > (item.count - 1)) ? (i + 2) - item.count : (i + 2)
//                self.cardBtns[item[i]].frame.origin = itemPosition[j]
//            }
//            self.MultiGameCardChange2(item, itemSize)
//        }
        
    }
    func MultiGameCardChange2(_ item: [Int]) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .transitionFlipFromLeft, animations: {[weak self] in
            guard let self = self else { return }
            for i in 0..<item.count {
                self.cardBtns[item[i]].alpha = 1
            }
        }) {[weak self] (completion) in
            guard let self = self else { return }
            guard completion else { return }
            self.registerGameTime()
            self.timeBool = false
            for i in 0..<item.count {
                self.cardBtns[item[i]].setImage(nil, for: .normal)
            }
        }
//        UIView.animate(withDuration: 1, animations: {[weak self] in
//            guard let self = self else { return }
//            for i in 0..<item.count {
//                self.cardBtns[item[i]].isHidden = true
//            }
//        }) {[weak self] (completion) in
//            guard let self = self else { return }
//            guard completion else { return }
//            self.registerGameTime()
//            self.timeBool = false
//        }
    }
    func GameCardPufferlock() {
        let item = cardGame.getPufferTransfer()
        for i in 0..<item.count {
            cardBtns[item[i]].isEnabled = false
            cardBtns[item[i]].setImage(UIImage(named: "w"), for: .normal)
        }
    }
    func GameCardPufferunlock(_ cardNum: Int) {
        let item = cardGame.getCardBeside(cardNum)
        for i in 0..<item.count {
            cardBtns[item[i]].isEnabled = true
            if !cardGame.gameCards[cardBtns[item[i]].tag].isDrawed {
                cardBtns[item[i]].setImage(nil, for: .normal)
            }
            
            cardGame.addItem(item[i])
        }
    }
    var lightNum = 1
    var lightB = true
    func lightChange() {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        view.backgroundColor = .clear
        view.isHidden = true
        self.GameView.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        UIView.animate(withDuration: 0.1, animations: {
            view.isHidden = false
            view.backgroundColor = (self.lightB) ? .white : .black
        }) {[weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.lightNum += 1
                self.lightB = !self.lightB
                view.removeFromSuperview()
                if self.lightNum == 6 {
                    return
                }
                self.lightChange()
            }
        }
    }
    
    // MARK: - Game Resault
    func GameOver() {
        MusicEffect.shared.fail?.play()
        let gameOverVC = GameOverVC()
        gameOverVC.goBack = {[weak self] in
            guard let self = self else { return }
            self.goBack()
            gameOverVC.remove()
        }
        self.add(gameOverVC)
        gameOverVC.view.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    func GameWin() {
        MusicEffect.shared.success?.play()
        let gameScoreVC = GameScoreVC(cardGame.gameSpecial, gameModel.mode)
        self.add(gameScoreVC)
        gameScoreVC.view.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Timer
    func registerReciprocal() {
        specialView.isHidden = true
        readyView.isHidden = false
        ready = 5
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runReciprocal(_:)), userInfo: nil, repeats: true)
    }
    func registerGameTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runGameTime(_:)), userInfo: nil, repeats: true)
    }
    @objc func runReciprocal(_ timer: Timer) -> Void {
        if ready == 1 {
            gameReadyPlay()
            return
        }
        ready -= 1
    }
    @objc func runGameTime(_ timer: Timer) -> Void {
        if time == 3, cardGame.mode == .puffer || cardGame.mode == .shantou {
            GameCardPufferlock()
        }
        if cardGame.mode == .lantern || cardGame.mode == .shantou {
            if (time % 20) == 10 {
                lightNum = 1
                lightB = false
                lightChange()
                lanternBool = true
            } else if (time % 20) == 0 {
                lightNum = 1
                lightB = true
                lightChange()
                lanternBool = false
            }
        }
        if time != 0, cardGame.transfer(time) {
            timeBool = true
        }
        if btnBool, timeBool {
            self.releaseTimer()
            effectTime = 0
            switch cardGame.mode {
            case .octopus, .shantou:
                MultiGameCardChange()
            default:
                GameCardChange()
            }
        }
        time += 1
    }
    func releaseTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - cardbtn click
    var lastClick: Int?
    var btnBool = true
    var timeBool = false
    var lanternBool = false
    @objc func CardBtnPressed(_ sender: UIButton) {
        let index = sender.tag
        var card = cardGame.gameCards[index]
        if timeBool { return }
        if card.unClick { return }
        if card.isDrawed {
            return
        } else {
            cardGame.gameCards[index].isDrawed = true
        }
        btnBool = false
        MusicEffect.shared.flip?.play()
        var showImg = card.image
        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionFlipFromLeft, animations: {
            if self.lanternBool {
                sender.setBackgroundImage(nil, for: .normal)
                sender.setImage(UIImage(named: "card000"), for: .normal)
            } else {
                sender.setBackgroundImage(UIImage(named: "card0"), for: .normal)
                sender.setImage(UIImage(named: showImg), for: .normal)
                sender.imageView?.contentMode = .scaleAspectFit
            }
        }) {[weak self] (completion) in
            guard completion else { return }
            guard let self = self else { return }
            // get the last one card whick clicked
            if let lastClick = self.lastClick {
                // get the last card object
                let lastCard = self.cardGame.gameCards[lastClick]
                // judge two cards' img
                if lastCard.image == card.image {
                    MusicEffect.shared.flipsuccess?.play()
                    self.lastClick = nil
                    self.cardGame.uploadGameSpecial()
                    if self.lanternBool {
                        sender.backgroundColor = .clear
                        sender.setBackgroundImage(UIImage(named: "card0"), for: .normal)
                        sender.setImage(UIImage(named: showImg), for: .normal)
                        sender.imageView?.contentMode = .scaleAspectFit
                        
                        self.cardBtns[lastClick].backgroundColor = .clear
                        self.cardBtns[lastClick].setBackgroundImage(UIImage(named: "card0"), for: .normal)
                        self.cardBtns[lastClick].setImage(UIImage(named: showImg), for: .normal)
                        self.cardBtns[lastClick].imageView?.contentMode = .scaleAspectFit
                    }
                    self.GameCardPufferunlock(lastClick)
                    self.GameCardPufferunlock(index)
                    self.cardGame.matchCards(lastClick)
                    self.cardGame.matchCards(index)
                } else {
                    MusicEffect.shared.flipFail?.play()
                    self.cardBtns[lastClick].reset()
                    sender.reset()
                    self.cardGame.gameCards[index].isDrawed = false
                    self.cardGame.gameCards[lastClick].isDrawed = false
                    self.cardGame.addItem(lastClick)
                    self.lastClick = nil
                    self.cardGame.setGameSpecial()
                }
                self.gameSpecial()
            } else {
                self.lastClick = index
                self.cardGame.matchCards(index)
            }
            self.steps -= 1
            if self.cardGame.gameItems.count == 0 {
                self.releaseTimer()
                self.GameWin()
                return
            }
            if self.steps == 0 {
                self.releaseTimer()
                self.GameOver()
            }
            self.btnBool = true
        }
    }
    
}
