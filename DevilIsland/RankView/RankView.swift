//
//  RankView.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RankView: UIView {
    
    private var rankImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "rankbox")
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
    }()
    private var rank: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        label.text = (GameData.shared.rank != 0) ? "\(GameData.shared.rank) 名" : "---"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var viewTap: (() -> Void)?
    private var observer: NSKeyValueObservation!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    private func setUI() {
        observer = GameData.shared.observe(\.rank, options: [.new, .initial], changeHandler: { (object, change) in
            if object.rank != 0 {
                self.rank.text = (object.rank != 0) ? "\(object.rank) 名" : "---"
            }
        })
        self.backgroundColor = .clear
        setRankImg()
        setRank()
        setGesture()
    }
    private func setRankImg() {
        self.addSubview(rankImg)
        rankImg.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    private func setRank() {
        self.addSubview(rank)
        rank.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview().multipliedBy(1.3)
            maker.centerY.equalToSuperview().multipliedBy(0.9)
            maker.height.equalTo(self.frame.size.height / 3)
            maker.width.equalTo(self.frame.size.width / 2)
        }
    }
    private func setGesture() {
        let onTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        self.addGestureRecognizer(onTap)
    }
    @objc private func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        viewTap?()
    }
}
