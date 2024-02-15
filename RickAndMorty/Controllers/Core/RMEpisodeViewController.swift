//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

protocol RMEpisodeViewControllerDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// Controller to show and search for Episodes
final class RMEpisodeViewController: UIViewController {

    private let customView = RMEpisodeListView()
    private let viewModel: RMEpisodeViewModelDelegate = RMEpisodeViewModel()

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

        viewModel.setDelegate(self)
        viewModel.fetchEpisodes()
    }

    private func setUpView() {
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
        customView.collectionView.dataSource = self.viewModel.getInstance()
        customView.collectionView.delegate = self.viewModel.getInstance()
    }
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - RMEpisodeViewControllerDelegate

extension RMEpisodeViewController: RMEpisodeViewControllerDelegate {
    func didSelectEpisode(_ episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func didLoadInitialEpisodes() {
        customView.spinner.stopAnimating()
        customView.collectionView.isHidden = false
        customView.collectionView.reloadData()

        UIView.animate(withDuration: 0.4) {
            self.customView.collectionView.alpha = 1
        }
    }

    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.customView.collectionView.performBatchUpdates {
                self.customView.collectionView.insertItems(at: newIndexPaths)
            }
        }
    }

}
