//
//  LogoGamePlayViewModel.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

typealias OnNextPlayableLoad = () -> ()
typealias OnSolutionUpdate = () -> ()

protocol LogoGamePlayViewModelInputs {
    func startLevel()
    func update(solution: String)
    func reset()
}

protocol LogoGamePlayViewModelOutputs {
    var screenTitle: String { get set }
    var onPlayableLoad: OnNextPlayableLoad? { get set }
    var onSolutionUpdate: OnSolutionUpdate? { get set }
    var currentSolution: String { get set }
    var correctSolutionCount: Int { get set }
    
    func logoImage() -> UIImage?
    func shuffledPlayableText() -> String?
}

protocol LogoGamePlayViewModelType: LogoGamePlayViewModelInputs, LogoGamePlayViewModelOutputs {
    var inputs: LogoGamePlayViewModelInputs { get }
    var outputs:LogoGamePlayViewModelOutputs { get }
}

class LogoGamePlayViewModel: LogoGamePlayViewModelType {
    var inputs: LogoGamePlayViewModelInputs { return self }
    var outputs:LogoGamePlayViewModelOutputs { return self }
    
    private var currentPlayable: LogoPlayable?
    private var shuffledPlayable: String = ""
    private var gameLevelsViewModel: GameLevelsViewModelType?
    private var currentLevel: Int = 0
    
    // MARK: Outputs properties
    var onPlayableLoad: OnNextPlayableLoad?
    var onSolutionUpdate: OnSolutionUpdate?
    var screenTitle: String = ""
    var currentSolution: String = ""
    var correctSolutionCount: Int = 0
    
    init(currentLevel: Int, gameLevelsViewModel: GameLevelsViewModelType?) {
        self.currentLevel = currentLevel
        screenTitle = "Level".localized + " \(currentLevel + 1)"
        self.gameLevelsViewModel = gameLevelsViewModel
    }
    
    // MARK: Inputs
    func startLevel() {
        loadLevelLogos()
        loadNextPlayable()
    }
    
    func update(solution: String) {
        currentSolution.append(solution)
        if validate(solution: currentSolution) {
            markAsPlayed()
            loadNextPlayable()
        }
        onSolutionUpdate?()
    }
    
    func reset() {
        currentSolution = ""
        onSolutionUpdate?()
    }
    
    private func markAsPlayed() {
        currentPlayable?.hasAlreadyPlayed = true
    }
    
    private func loadNextPlayable() {
        currentPlayable = nextPlayable()
        shuffleText(for: currentPlayable?.name)
        currentSolution = ""
        onPlayableLoad?()
        correctSolutionCount = currentPlayable?.name?.count ?? 0
        loadNextPlayableLogo()
    }
    
    private func nextPlayable() -> LogoPlayable? {
        guard let gameLevel = gameLevelsViewModel?.level(for: currentLevel) else { return nil }
        var logoPlayable = gameLevel.playables.first { (playable) -> Bool in
            guard let logoPlayable = playable as? LogoPlayable else { return false }
            return gameLevelsViewModel?.outputs.logoImage(for: logoPlayable, levelIndex: currentLevel) != nil && !logoPlayable.hasAlreadyPlayed
        }
        if logoPlayable == nil {
            logoPlayable = gameLevel.playables.first { (playable) -> Bool in
                guard let logoPlayable = playable as? LogoPlayable else { return false }
                return gameLevelsViewModel?.outputs.logoImage(for: logoPlayable, levelIndex: currentLevel) != nil
            }
        }
        return logoPlayable as? LogoPlayable
    }
    
    private func loadNextPlayableLogo() {
        guard let playables = playables(),
            let playable = currentPlayable else { return }
        
        let index = playables.firstIndex(of: playable) ?? 0
        let _ = gameLevelsViewModel?.outputs.logoImage(for: playables[index+1], levelIndex: currentLevel)
    }
    
    private func loadLevelLogos() {
        guard let playables = playables() else { return }
        
        for playable in playables {
            let _ = gameLevelsViewModel?.outputs.logoImage(for: playable, levelIndex: currentLevel)
        }
    }
    
    private func playables() -> [LogoPlayable]? {
        guard let gameLevel = gameLevelsViewModel?.level(for: currentLevel),
            let playables = gameLevel.playables as? [LogoPlayable] else { return nil }
        
        return playables
    }
    
    private func validate(solution: String) -> Bool {
        return currentPlayable?.validate(solution: solution) ?? false
    }
    
    private func shuffleText(for name: String?) {
        guard var shuffledName = name else { return }
        
        let countToAdd = max(currentLevel + 2, 10)
        let shuffledAlphabets = "abcdefghijklmnopqrstuvwxyz".shuffled()
        let alphabets: [Character] = shuffledAlphabets.prefix { (character) -> Bool in
            return shuffledAlphabets.firstIndex(of: character) ?? 0 < countToAdd
        }
        shuffledName.append(String(alphabets))
        shuffledPlayable = String(shuffledName.shuffled()).uppercased()
    }
    
    // MARK: Outputs
    func logoImage() -> UIImage? {
        guard let playable = currentPlayable else { return nil }
        
        return gameLevelsViewModel?.outputs.logoImage(for: playable, levelIndex: currentLevel)
    }
    
    func shuffledPlayableText() -> String? {
        return shuffledPlayable
    }
}
