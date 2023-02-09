//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 27/01/23.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

    /// Configuration to search session
    struct Config {
        enum `Type` {
            case character
            case episode
            case location

            var title: String {
                switch self {
                    case .character:
                        return "Search Characters"
                    case .episode:
                        return "Search Episodes"
                    case .location:
                        return "Search Locations"
                }
            }

        }
        let type: `Type`
    }

    private let viewModel: RMSearchViewViewModel
    private let searchView: RMSearchView

    // MARK: - Init

    init(config: Config) {
        self.viewModel = RMSearchViewViewModel(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        setUpViews()
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }

    private func setUpViews() {
        view.addSubview(searchView)
        searchView.delegate = self
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }

}

// MARK: - RMSearchView delegate

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
}
