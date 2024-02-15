//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

protocol RMLocationViewControllerDelegate: AnyObject {
    func showLoadingIndicator()
    func didFetchInitialLocations()
    func didSelectLocation(location: RMLocation)
}

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {

    private let customView = RMLocationView()
    private let viewModel: RMLocationViewModelDelegate = RMLocationViewModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(didTapSearch))
        setUpView()
        addConstraints()
        bind()
        viewModel.fetchLocations()
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
    
    private func bind() {
        viewModel.setDelegate(self)
        customView.tableView.delegate = viewModel.getInstance()
        customView.tableView.dataSource = viewModel.getInstance()
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - RMLocationViewControllerDelegate Delegate

extension RMLocationViewController: RMLocationViewControllerDelegate {
    func showLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        customView.tableView.tableFooterView = footer
    }
    
    func didFetchInitialLocations() {
        customView.spinner.stopAnimating()
        customView.tableView.isHidden = false
        customView.tableView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.customView.tableView.alpha = 1
        }

        viewModel.registerDidFinishPaginationBlock { [weak self] in
            DispatchQueue.main.async {
                self?.customView.tableView.tableFooterView = nil
                self?.customView.tableView.reloadData()
            }
        }
    }
    
    func didSelectLocation(location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
