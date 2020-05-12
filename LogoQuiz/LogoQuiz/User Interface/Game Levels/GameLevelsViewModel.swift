//
//  GameLevelsViewModel.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

typealias ImageLoadCompletion = (_ image: UIImage) -> ()

protocol LogoRequester {
    var onLogoImageLoad: ImageLoadCompletion? { get set }
}

protocol GameDataRequester {

    func gameDataLoadedSuccessfully()
}

protocol GameLevelsViewModelInputs {
    func set(gameDataRequester: GameDataRequester)
    func update(game: LogoQuizGame)
    func update(gameScore: Int)
    func update(numberOfLives: Int)
}

protocol GameLevelsViewModelOutputs {
    func numberOfLevels() -> Int
    func gameName() -> String
    func gameScore() -> Int
    func levelTitle(for index: Int) -> String
    func canPlayLevel(for index: Int) -> Bool
    func levelState(for index: Int) -> LevelState
    
    func level(for index: Int) -> GameLevelType?
    func nextPlayable(for level: Int) -> LogoPlayable?
    func logoImage(for playable: LogoPlayable, levelIndex: Int) -> UIImage?
}

protocol GameLevelsViewModelType: GameLevelsViewModelInputs, GameLevelsViewModelOutputs {
    var inputs: GameLevelsViewModelInputs { get }
    var outputs: GameLevelsViewModelOutputs { get }
}

class GameLevelsViewModel: GameLevelsViewModelType, LogoRequester {
    var inputs: GameLevelsViewModelInputs { return self }
    var outputs: GameLevelsViewModelOutputs { return self }
    var onLogoImageLoad: ImageLoadCompletion?

    private var game: LogoQuizGame?
    private var logoRequester: LogoRequester?
    private var gameDataRequester: GameDataRequester?
    private let levelsCount = 10
    private let maxHintsAllowed = 5
    private var logoManager: LogoManager?
    
    
    init() {
        setUpViewModel()
    }
    
    private func setUpViewModel() {
        if let playables = loadLogoJson() {
            setUpGame(playables: playables)
            loadLogoData(for: game, onLogoImageLoad: self.onLogoImageLoad)
        }
    }
    
    private func loadLogoJson() -> [LogoPlayable]? {
        return JSONFileLoader.load(filename: "logo", into: [LogoPlayable].self)
    }
    
    private func setUpGame(playables: [LogoPlayable]) {
        var levels = [LogoQuizGameLevel]()
        for index in 0..<levelsCount {
            let level = LogoQuizGameLevel(number: index, achievedScore: nil, playables: playables)
            levels.append(level)
        }
        game = LogoQuizGame(levels: levels, achievedScore: nil, numberOfLives: maxHintsAllowed, consumedLives: 0, lastUnlockedLevel: 0)
            
        gameDataRequester?.gameDataLoadedSuccessfully()
    }
    
    private func loadLogoData(for game: LogoQuizGame?, onLogoImageLoad: ImageLoadCompletion?) {
        logoManager = LogoManager(game: game, onLogoImageLoad: onLogoImageLoad)
        logoManager?.loadLogoImages()
    }
    
    // MARK: Inputs
    func set(gameDataRequester: GameDataRequester) {
        self.gameDataRequester = gameDataRequester
    }

    func update(game: LogoQuizGame) {
        self.game = game
    }
    
    func update(gameScore: Int) {
        
    }
    
    func update(numberOfLives: Int) {
        
    }
    
    // MARK: outputs
    func numberOfLevels() -> Int {
        return game?.levels.count ?? 1
    }
    
    func gameName() -> String {
        return game?.name.localized ?? "Logo Quiz".localized
    }
    
    func gameScore() -> Int {
        return game?.achievedScore ?? 0
    }
    
    func levelTitle(for index: Int) -> String {
        return "\(index + 1)".localized
    }
    
    func canPlayLevel(for index: Int) -> Bool {
        return index <= lastUnlockedLevel()
        
    }
    
    func levelState(for index: Int) -> LevelState {
        var state = LevelState.locked
        if index == lastUnlockedLevel() {
            state = .playing
        } else if index < lastUnlockedLevel() {
            state = .played
        }
        return state
    }
    
    func level(for index: Int) -> GameLevelType? {
        return game?.levels[index]
    }
    
    func nextPlayable(for levelIndex: Int) -> LogoPlayable? {
        guard let gameLevel = game?.levels[levelIndex] else { return nil }
        let logoPlayable = gameLevel.playables.first { (playable) -> Bool in
            guard let logoPlayable = playable as? LogoPlayable else { return false }
            return logoManager?.loadLogoImage(for: logoPlayable.imageUrl) != nil && !logoPlayable.hasAlreadyPlayed
        }
        return logoPlayable as? LogoPlayable
    }
    
    func logoImage(for playable: LogoPlayable, levelIndex: Int) -> UIImage? {
        guard let imageUrl = playable.imageUrl else { return nil }
        
        return logoManager?.loadLogoImage(for: imageUrl)
    }
    
    private func lastUnlockedLevel() -> Int {
        let level = game?.levels.first { (gameLevel) -> Bool in
            return gameLevel.achievedScore != nil
        }
        return level?.number ?? 0
    }
}
