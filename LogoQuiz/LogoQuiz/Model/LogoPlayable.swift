//
//  LogoPlayable.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

class LogoPlayable: NSObject, Decodable {
    var imageUrl: String?
    var name: String?
    private var isPlayed = false
    
    private enum CodingKeys: String, CodingKey {
        case imageUrl = "imgUrl"
        case name
    }
}

extension LogoPlayable: PlayableValidator {
    var hasAlreadyPlayed: Bool {
        get {
            return isPlayed
        }
        set {
            isPlayed = newValue
        }
    }
    
    func validate(solution: String) -> Bool {
        return name?.uppercased() == solution.uppercased()
    }
}
