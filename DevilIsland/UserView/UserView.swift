//
//  UserView.swift
//  DevilIsland
//
//  Created by Apple on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit

class UserView: UIView {
    
    private var starArray = [UIImageView]()
    
    private var userImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "userbox")
        img.contentMode = UIView.ContentMode.scaleAspectFit
        return img
    }()
    private var starStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution = UIStackView.Distribution.fillEqually
        stack.spacing = 0
        return stack
    }()
    private var score: UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 17)
        label.text = "\(GameData.shared.score)"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var observer: NSKeyValueObservation!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI()
    }
    
    private func setUI() {
        observer = GameData.shared.observe(\.score, options: [.new, .initial], changeHandler: { (object, change) in
            self.score.text = "\(change.newValue ?? 0)"
        })
        self.backgroundColor = .clear
        setUserImg()
        setStackView()
        setScore()
//        setGesture()
    }
    private func setUserImg() {
        self.addSubview(userImg)
        userImg.snp.makeConstraints { (maker) in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    private func setStackView() {
        self.addSubview(starStack)
        starStack.snp.makeConstraints { (maker) in
            maker.bottom.trailing.equalToSuperview()
            maker.height.equalTo(self.frame.size.height * (1/3))
            maker.width.equalTo(self.frame.size.height * (5/3))
        }
        setStar()
    }
    private func setStar() {
        starArray.removeAll()
        for i in 1...5 {
            let img = UIImageView()
            if i > GameData.shared.star {
                img.image = UIImage(named: "userstar2")
            } else {
                img.image = UIImage(named: "userstar")
            }
            starArray.append(img)
            starStack.addArrangedSubview(img)
        }
    }
    private func setScore() {
        self.addSubview(score)
        score.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview().multipliedBy(1.3)
            maker.centerY.equalToSuperview().multipliedBy(0.9)
            maker.height.equalTo(self.frame.size.height / 3)
            maker.width.equalTo(self.frame.size.width / 2)
        }
    }
    
    func updateStar() {
        for i in 0..<starArray.count {
            if (i + 1) > GameData.shared.star {
                starArray[i].image = UIImage(named: "userstar2")
            } else {
                starArray[i].image = UIImage(named: "userstar")
            }
        }
    }
}
