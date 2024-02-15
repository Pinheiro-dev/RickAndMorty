//
//  RMEpisodeViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 20/01/23.
//

import UIKit

protocol RMEpisodeViewModelDelegate: AnyObject {
    func getInstance() -> NSObject & UICollectionViewDataSource & UICollectionViewDelegate
    func setDelegate(_ delegate: RMEpisodeViewControllerDelegate?)
    /// Fetch inital set of episodes (20)
    func fetchEpisodes()
    /// Paginate if additional episodes are needed
    func fetchAddtionalEpisodes(url: URL)
    var shouldShowLoadMoreIndicator: Bool { get }
}

/// View Model to handle episode list view logic
final class RMEpisodeViewModel: NSObject, RMEpisodeViewModelDelegate {

    weak var delegate: RMEpisodeViewControllerDelegate?

    private var isLoadingMoreEpisodes = false

    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: .secondaryLabel,
                    backgroundColor: .systemBackground
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }

            }
        }
    }

    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []

    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    //MARK: - Actions
    
    func getInstance() -> NSObject & UICollectionViewDataSource & UICollectionViewDelegate {
        return self
    }
    
    func setDelegate(_ delegate: RMEpisodeViewControllerDelegate?) {
        self.delegate = delegate
    }

    func fetchEpisodes() {
        RMService.shared.execute(.listEpisodesRequest,
                                 expecting: RMGetAllEpisodesResponse.self,
                                 completion: { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self?.episodes = results
                    self?.apiInfo = info
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialEpisodes()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        })
    }

    func fetchAddtionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }

        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    self.apiInfo = info

                    let originalCount = self.episodes.count
                    let newCount = moreResults.count
                    let total = originalCount+newCount
                    let startingIndex = total - newCount
                    let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    self.episodes.append(contentsOf: moreResults)

                    DispatchQueue.main.async {
                        self.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                        self.isLoadingMoreEpisodes = false
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self.isLoadingMoreEpisodes = false
            }
        }
    }

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension RMEpisodeViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: cellViewModels[indexPath.row])
        return cell
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

        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20

        return CGSize(width: width,
                      height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }

}

// MARK: - ScrollView
extension RMEpisodeViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAddtionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
