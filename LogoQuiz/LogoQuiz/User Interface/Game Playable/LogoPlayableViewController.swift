//
//  LogoPlayableViewController.swift
//  LogoQuiz
//
//  Created by Neelu Pasricha on 5/10/20.
//  Copyright © 2020 Assignment. All rights reserved.
//

import UIKit

class LogoPlayableViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var guessedCollectionView: UICollectionView!
    @IBOutlet weak var shuffledCollectionView: UICollectionView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var viewModel: LogoGamePlayViewModel!
    
    private let cellIdentifier = "AlphabetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.outputs.screenTitle
        bindViewModel()
        viewModel.inputs.startLevel()
    }
    
    private func bindViewModel() {
        viewModel.onPlayableLoad = { [weak self] in
            self?.logoImageView.image = self?.viewModel.outputs.logoImage()
            self?.guessedCollectionView.reloadData()
            self?.shuffledCollectionView.reloadData()
        }
        
        viewModel.onSolutionUpdate = {[weak self] in
            self?.guessedCollectionView.reloadData()
            self?.shuffledCollectionView.reloadData()
        }
    }
    
    @IBAction func resetPlayable(_ sender: Any) {
        viewModel.inputs.reset()
    }
    
    @IBAction func changeGameState(_ sender: Any) {
        
    }
}

extension LogoPlayableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? AlphabetCollectionViewCell else { return }
        if collectionView == shuffledCollectionView {
            if !cell.isTaken {
                cell.isTaken = true
                viewModel.update(solution: cell.value)
            }
        }
    }
}

extension LogoPlayableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == guessedCollectionView {
            return viewModel.outputs.correctSolutionCount
        } else {
            return viewModel.shuffledPlayableText()?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? AlphabetCollectionViewCell else { return UICollectionViewCell() }
        
        var value = ""
        if collectionView == guessedCollectionView {
            let currentSolution = viewModel.outputs.currentSolution
            
            if currentSolution.count > indexPath.item {
                let currentSolutionIndexed = Array(currentSolution)
                value = String(currentSolutionIndexed[indexPath.item])
            }
            cell.isTaken = (value.count == 0)
        } else {
            if let shuffledPlayableName = viewModel.outputs.shuffledPlayableText(), shuffledPlayableName.count > indexPath.item {
                let shuffledPlayableIndexed = Array(shuffledPlayableName)
                value = String(shuffledPlayableIndexed[indexPath.item])
            }
            cell.isTaken = (value.count == 0)
        }
        cell.value = value
        return cell
    }
}
