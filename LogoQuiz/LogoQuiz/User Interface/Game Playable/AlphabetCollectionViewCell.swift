//
//  AlphabetCollectionViewCell.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/11/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

class AlphabetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!
        
    var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }
    
    var isTaken: Bool = false {
        didSet {
            valueLabel.isHidden = isTaken
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 4.0
    }
    
}
