//
//  RankVC.swift
//  DevilIsland
//
//  Created by Apple on 7/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LeanCloud

struct RankModel {
    var id: String
    var score: Int
    var rank: Int
    var user: Bool
}

class RankVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var rankTable: UITableView!
    @IBOutlet weak var FirstView: UIView!
    
    var listData = [RankModel]()
    var closeView: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RankCell", bundle: nil)
        rankTable.register(nib, forCellReuseIdentifier: "RankCell")
        
        if GameData.shared.objectId != "" {
            FirstView.isHidden = true
            getData()
        }
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { checkLabel.isHidden=false;return true }
        let count = text.count + string.count - range.length
        return count <= 8
    }
    
    // MARK: - Data
    func getData() {
        let cql = "select * from userscore order by score desc"
        
        _ = LCCQLClient.execute(cql) { result in
            switch result {
            case .success(let result):
                let todos = result.objects
                self.cleanData(todos)
            case .failure(let error):
                print(error)
            }
        }
    }
    func cleanData(_ data: [LCObject]) {
        listData.removeAll()
        var user = false
        for i in 0..<data.count {
            let id = data[i]["user"]?.stringValue
            let score = data[i]["score"]?.intValue
            let objc = data[i]["objectId"]?.stringValue
            let userB = (objc! == GameData.shared.objectId) ? true : false
            listData.append(RankModel(id: id!, score: score!, rank: i, user: userB))
        }
        rankTable.reloadData()
    }
    
    // MARK: - table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = rankTable.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankCell
        cell.userID.text = cellData.id
        cell.userScore.text = "\(cellData.score)"
        switch cellData.rank {
        case 0:
            cell.rankImg.image = UIImage(named: "s1")
        case 1:
            cell.rankImg.image = UIImage(named: "s2")
        case 2:
            cell.rankImg.image = UIImage(named: "s3")
        default:
            cell.rankImg.image = nil
        }
        if cellData.user {
            cell.cellView.backgroundColor = .yellow
        }
        
        return cell
    }

    @IBAction func userClick(_ sender: UIButton) {
        guard let text = userTF.text else { checkLabel.isHidden=false;return }
        do {
            let todo = LCObject(className: "userscore")
            try todo.set("user", value: text)
            try todo.set("score", value: GameData.shared.score)
            let _ = todo.save { (result) in
                switch result {
                case .success:
                    // handle object
                    GameData.shared.objectId = todo.objectId!.stringValue!
                    GameData.shared.saveObjectId()
                    GameData.shared.getRank()   
                    self.FirstView.isHidden = true
                    self.getData()
                    break
                case .failure(error: let error):
                    // handle error
                    break
                }
            }
        } catch {
            // handle error
        }
        
    }
    @IBAction func closeClick(_ sender: UIButton) {
        self.remove()
//        closeView?()
    }
}
