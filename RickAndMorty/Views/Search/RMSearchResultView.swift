//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 06/03/23.
//

import UIKit

protocol RMSearchResulsViewDelegate: AnyObject {
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapLocationAt index: Int)
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapCharacterAt index: Int)
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapEpisodeAt index: Int)
}

/// Shows search results UI (table or collection as needed)
final class RMSearchResultView: UIView {

    weak var delegate: RMSearchResulsViewDelegate?

    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self,
                       forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()

    /// TableView viewModels
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []

    /// CollectionView viewModels
    private var collectionViewCellViewModels: [any Hashable] = []

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        addSubviews(tableView, collectionView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel.results {
            case .characters(let viewModels):
                setUpCollectionView(viewModels: viewModels)
            case .episodes(let viewModels):
                setUpCollectionView(viewModels: viewModels)
            case .locations(let viewModels):
                setUpTableView(viewModels: viewModels)
        }
    }

    private func setUpCollectionView(viewModels: [any Hashable]) {
        self.collectionViewCellViewModels = viewModels
        collectionView.delegate = self
        collectionView.dataSource = self

        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        self.locationCellViewModels = viewModels
        tableView.delegate = self
        tableView.dataSource = self

        collectionView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
    
}

// MARK: - TableView delegate

extension RMSearchResultView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RMLocationTableViewCell else {
            return UITableViewCell()
        }

        let data = locationCellViewModels[indexPath.row]
        cell.configure(with: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - CollectionView delegate

extension RMSearchResultView:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel { // Character
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: characterVM)
            return cell
        } else if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel { // Episode
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                                                                for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: episodeVM)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel.results {
            case .characters:
                delegate?.rmSearchResultView(self, didTapCharacterAt: indexPath.row)
            case .episodes:
                delegate?.rmSearchResultView(self, didTapEpisodeAt: indexPath.row)
            case .locations:
                break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        let bounds = collectionView.bounds

        if currentViewModel is RMCharacterCollectionViewCellViewModel { // Character
            let width = UIDevice.isIphone ? (bounds.width-30)/2 : (bounds.width-50)/4
            return CGSize(width: width,
                          height: width * 1.5)
        } else { // Episode
            let width = UIDevice.isIphone ? bounds.width-20 : (bounds.width-50) / 4
            return CGSize(width: width,
                          height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView else {
            return UICollectionReusableView()
        }
        if let viewModel = viewModel,
           viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }

}

// MARK: - Scrollview delegate

extension RMSearchResultView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !collectionViewCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                viewModel.fetchAddtionalResults { [weak self] newResults in
                    guard let self = self else {
                        return
                    }

                    DispatchQueue.main.async {
                        let originalCount = self.collectionViewCellViewModels.count
                        let newCount = (newResults.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(total)).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
                        self.collectionViewCellViewModels = newResults
                        self.collectionView.insertItems(at: indexPathToAdd)
                    }
                }
            }
            t.invalidate()
        }
    }

    private func handleLocationPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showTableLoadingIndicator()
                }
                viewModel.fetchAddtionalLocations { [weak self] newResults in
                    // Refresh table
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    self?.tableView.reloadData()
                }
            }
            t.invalidate()
        }
    }

    private func showTableLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }

}
