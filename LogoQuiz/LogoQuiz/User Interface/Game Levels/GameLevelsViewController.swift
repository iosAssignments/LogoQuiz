//
//  GameLevelsViewController.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

class GameLevelsViewController: UIViewController {

    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameLevelsCollectionView: UICollectionView!
    
    private let gameLevelCellIdentifier = "LevelCell"
    var viewModel: GameLevelsViewModelType!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        gameTitleLabel.text = viewModel.outputs.gameName()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gamePlayViewControler = segue.destination as? LogoPlayableViewController {
            navigationController?.navigationBar.isHidden = false
            
            let selectedIndex = gameLevelsCollectionView.indexPath(for: sender as! UICollectionViewCell)?.item ?? 0
            let logoPlayableViewModel = LogoGamePlayViewModel(currentLevel: selectedIndex, gameLevelsViewModel: viewModel)
            gamePlayViewControler.viewModel = logoPlayableViewModel
        }
    }
}

extension GameLevelsViewController: UICollectionViewDelegate {
}

extension GameLevelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputs.numberOfLevels()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let levelCell = collectionView.dequeueReusableCell(withReuseIdentifier: gameLevelCellIdentifier, for: indexPath) as? GameLevelCollectionViewCell {
            let levelTitle = viewModel.outputs.levelTitle(for: indexPath.item)
            let levelState = viewModel.outputs.levelState(for: indexPath.item)
            
            levelCell.update(for: levelTitle, levelState: levelState)
            return levelCell
        }
        return UICollectionViewCell()
    }
}

extension GameLevelsViewController: GameDataRequester {
    func gameDataLoadedSuccessfully() {
        gameLevelsCollectionView.reloadData()
    }
}
