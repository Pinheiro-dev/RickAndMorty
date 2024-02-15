//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

protocol RMCharacterViewControllerDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    private let customView = RMCharacterListView()
    private let viewModel: RMCharacterViewModelDelegate = RMCharacterViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        addConstraints()
        setupCollectionView()

        viewModel.setDelegate(self)
        viewModel.fetchCharacters()
    }

    private func setupView() {
        view.addSubview(customView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.topAnchor),
            customView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            customView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            customView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        customView.collectionView.dataSource = viewModel.getInstance()
        customView.collectionView.delegate = viewModel.getInstance()
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - RMCharacterViewControllerDelegate

extension RMCharacterViewController: RMCharacterViewControllerDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func didLoadInitialCharacters() {
        customView.spinner.stopAnimating()
        customView.collectionView.isHidden = false
        customView.collectionView.reloadData()

        UIView.animate(withDuration: 0.4) {
            self.customView.collectionView.alpha = 1
        }
    }

    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.customView.collectionView.performBatchUpdates {
                self.customView.collectionView.insertItems(at: newIndexPaths)
            }
        }
    }

}
