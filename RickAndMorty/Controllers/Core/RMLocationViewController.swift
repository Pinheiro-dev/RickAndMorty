//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {

    private let primaryView = RMLocationView()

    private let viewModel = RMLocationViewViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        setUpView()
        addConstraints()
        primaryView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
    }

    func setUpView() {
        view.addSubview(primaryView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - LocationViewModel Delegate

extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }

}

// MARK: - LocationView Delegate

extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
