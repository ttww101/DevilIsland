//
//  RankCell.swift
//  DevilIsland
//
//  Created by Apple on 7/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var rankImg: UIImageView!
    @IBOutlet weak var userID: UILabel!
    @IBOutlet weak var userScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        cellView.backgroundColor = UIColor(red: 197/255, green: 241/255, blue: 255/255, alpha: 1)
        rankImg.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
