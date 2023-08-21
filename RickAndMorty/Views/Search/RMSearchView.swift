//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView,
                      didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView,
                      didSelectLocation location: RMLocation)
    func rmSearchView(_ inputView: RMSearchView,
                           didChangeSearchText text: String)
    func rmSearchViewDidTapSearchKeyboardButton(_ inputView: RMSearchView)
}

final class RMSearchView: UIView {

    weak var delegate: RMSearchViewDelegate?

    private let viewModel: RMSearchViewViewModel

    private let searchInputView = RMSearchInputView()
    private let noResultsView = RMNoSearchResultView()
    private let resultsView = RMSearchResultView()

    // MARK: - Init

    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        addConstraints()

        setUpHandlers(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        addSubviews(resultsView, noResultsView, searchInputView)
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        resultsView.delegate = self
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),

            // Results
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func setUpHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock{ tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }

        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

    public func hideKeyboard() {
        searchInputView.hideKeyboard()
    }

}

// MARK: - CollectionView 

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}

// MARK: - SearchInputView delegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        delegate?.rmSearchView(self, didChangeSearchText: text)
    }

    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        delegate?.rmSearchViewDidTapSearchKeyboardButton(self)
    }

}

extension RMSearchView: RMSearchResulsViewDelegate {
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
}
