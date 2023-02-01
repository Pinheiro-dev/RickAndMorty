//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {
    private let viewModel: RMLocationDetailViewViewModel
    private let location: RMLocation
    private let detailView = RMLocationDetailView()

    // MARK: - Init

    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = location.name
        setUpViews()
        addConstraints()
        detailView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func setUpViews() {
        view.addSubview(detailView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapShare() {

    }
}

// MARK: - ViewModel Delegate

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate {
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }

//    func didFetchEpisodeDetals() {
//        detailView.configure(with: viewModel)
//    }
}

// MARK: - ViewDetail Delegate

extension RMLocationDetailViewController: RMLocationDetailViewDelegate {
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelectCharacter character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

//    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelectCharacter character: RMCharacter) {
//        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
