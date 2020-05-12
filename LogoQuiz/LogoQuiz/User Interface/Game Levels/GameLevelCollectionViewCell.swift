//
//  GameLevelCollectionViewCell.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

enum LevelState {
    case played
    case playing
    case locked
}

class GameLevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 4.0
    }
    
    func update(for title: String, levelState: LevelState) {
        titleLabel.text = title
        
        updateUI(for: levelState)
    }
    
    private func updateUI(for state: LevelState) {
        if state == .locked {
            alpha = 0.6
        } else {
            alpha = 1.0
        }
    }
}
