//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let episodeListView = RMEpisodeListView()
    private let viewModel = RMEpisodeListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addConstraints()
        setupCollectionView()

        viewModel.delegate = self
        viewModel.fetchEpisodes()
    }

    private func setUpView() {
        view.addSubview(episodeListView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        episodeListView.collectionView.dataSource = self.viewModel
        episodeListView.collectionView.delegate = self.viewModel
    }
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - RMEpisodeListViewModelDelegate

extension RMEpisodeViewController: RMEpisodeListViewModelDelegate {
    func didSelectEpisode(_ episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func didLoadInitialEpisodes() {
        self.episodeListView.loadInitialEpisodes()
    }

    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        self.episodeListView.loadMoreEpisodes(with: newIndexPaths)
    }

}
