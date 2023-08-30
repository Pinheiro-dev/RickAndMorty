//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    private let characterListView = RMCharacterListView()
    private let viewModel = RMCharacterListViewModel()

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

        viewModel.delegate = self
        viewModel.fetchCharacters()
    }

    private func setupView() {
        view.addSubview(characterListView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        characterListView.collectionView.dataSource = viewModel
        characterListView.collectionView.delegate = viewModel
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - RMCharacterListViewModelDelegate

extension RMCharacterViewController: RMCharacterListViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func didLoadInitialCharacters() {
        self.characterListView.loadInitialCharacters()
    }

    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        self.characterListView.loadMoreCharacters(with: newIndexPaths)
    }

}
