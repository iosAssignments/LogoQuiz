//
//  LogoManager.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/12/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

class LogoManager: LogoRequester {
    private var logoCache = [String: UIImage]()
    private var game: LogoQuizGame?
    var onLogoImageLoad: ImageLoadCompletion?
    
    init(game: LogoQuizGame?, onLogoImageLoad: ImageLoadCompletion?) {
        self.onLogoImageLoad = onLogoImageLoad
        self.game = game
    }
        
    func loadLogoImages() {
        guard let gameLevels = game?.levels else { return }
        
        for level in gameLevels {
            if let playable = level.playables.first as? LogoPlayable {
                let _ = loadLogoImage(for: playable.imageUrl ?? "")
            }
        }
    }
    
    func loadLogoImage(for imageUrl: String?) -> UIImage? {
        guard let url = imageUrl else { return nil }
        
        if logoCache[url] != nil {
            return logoCache[url]
        }
                
        
        LogoService().getLogo(for: url) { (logoImage, error) in
            guard let image = logoImage else {
                return
            }
            
            self.logoCache[url] = image
            self.onLogoImageLoad?(image)
        }
        return nil
    }
}
