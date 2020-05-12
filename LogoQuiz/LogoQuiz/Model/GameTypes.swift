//
//  GameTypes.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import Foundation

protocol GameType {
    var name: String { get }
    var numberOfLives: Int { get }
    var levels: [GameLevelType]! { get }
    
    var achievedScore: Int? { get set }
    var consumedLives: Int { get set }
    var lastUnlockedLevel: Int { get set }
}

protocol GameLevelType {
    var levelScore: Int { get }
    var timerDuration: Int { get }

    var number: Int { get set }
    var achievedScore: Int? { get set }
    var isLocked: Bool { get set }
    var playables: [PlayableValidator] { get set }
}

// MARK: Logo Quiz Protocols
protocol PlayableValidator {
    var hasAlreadyPlayed: Bool { get set }
    func validate(solution: String) -> Bool
}

// MARK: Types
class LogoQuizGame: GameType {
    var name: String {
        return "Logo Quiz"
    }
    var levels: [GameLevelType]!
    var achievedScore: Int?
    var numberOfLives: Int = 5
    var consumedLives: Int = 0
    var lastUnlockedLevel: Int = 1
    
    init(levels: [GameLevelType], achievedScore: Int?, numberOfLives: Int = 5, consumedLives: Int = 0, lastUnlockedLevel: Int = 1) {
        self.levels = levels
        self.achievedScore = achievedScore
        self.numberOfLives = numberOfLives
        self.consumedLives = consumedLives
        self.lastUnlockedLevel = lastUnlockedLevel
    }
}

class LogoQuizGameLevel: GameLevelType {
    var levelScore: Int {
        return playables.count
    }
    var timerDuration: Int {
        return playables.count - number * 10
    }
    var number: Int = 0
    var achievedScore: Int?
    var playables: [PlayableValidator] = []
    var isLocked: Bool = true
    
    init(number: Int, achievedScore: Int?, playables: [PlayableValidator], isLocked: Bool = true) {
        self.number = number
        self.achievedScore = achievedScore
        self.playables = playables
    }
}
