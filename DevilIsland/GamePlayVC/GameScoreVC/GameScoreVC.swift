//
//  GameScoreVC.swift
//  DevilIsland
//
//  Created by Apple on 6/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum GameScoreType {
    case normal, pass, total
    
    var title: String {
        switch self {
        case .normal:
            return "连续翻牌 Ｘ "
        case .pass:
            return "过关奖励"
        case .total:
            return "分数统计"
        }
    }
}

struct GameScoreModel {
    var tint: String
    var score: Int
    var type: GameScoreType
    var animatBool: Bool = false
}

class GameScoreVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gameScoreTable: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    var scoreData = [GameScoreModel]()
    var tableData = [GameScoreModel]()
    
    init(_ score: [Int], _ mode: GameMode) {
        super.init(nibName: "GameScoreVC", bundle: nil)
        ScoreData(score, mode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameScoreTable.register(UINib(nibName: "GameScoreCell", bundle: nil), forCellReuseIdentifier: "GameScoreCell")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().async {
            for i in 0..<self.scoreData.count {
                let sleepTime = UInt32(0.5 * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.tableData.append(self.scoreData[i])
                    self.gameScoreTable.reloadData()
                    self.gameScoreTable.scrollToRow(at: IndexPath(row: i, section: 0), at: .bottom, animated: true)
                }
            }
        }
    }
    
    func ScoreData(_ score: [Int], _ mode: GameMode) {
        var total = 0
        for i in 0..<score.count {
            if score[i] != 0 {
                let culScore = mode.basicScore * score[i]
                total += culScore
                scoreData.append(GameScoreModel(tint: "\(score[i])", score: culScore, type: .normal, animatBool: false))
            }
        }
        scoreData.append(GameScoreModel(tint: "", score: 1000, type: .pass, animatBool: false))
        scoreData.append(GameScoreModel(tint: "", score: total, type: .total, animatBool: false))
        GameData.shared.score += total
        GameData.shared.saveScore()
    }
    @IBAction func backToMap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - table view datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellData = tableData[indexPath.row]
        let cell = gameScoreTable.dequeueReusableCell(withIdentifier: "GameScoreCell", for: indexPath) as! GameScoreCell
        cell.score = cellData.score
        cell.animat = cellData.animatBool
        cell.setTitle(cellData.type, tint: cellData.tint)
        cell.playScoreAnimat()
        cell.finishAni = {[weak self] in
            self?.tableData[indexPath.row].animatBool = true
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rowCell = cell as! GameScoreCell
//    }
}
