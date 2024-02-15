//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 31/01/23.
//

import Foundation
import UIKit

protocol RMLocationViewModelDelegate: AnyObject {
    func getInstance() -> NSObject & UITableViewDelegate & UITableViewDataSource
    func setDelegate(_ delegate: RMLocationViewControllerDelegate?)
    func registerDidFinishPaginationBlock(_ block: @escaping () -> Void)
    func location(at index: Int) -> RMLocation?
    func fetchLocations()
    /// Paginate if additional locations are needed
    func fetchAddtionalLocations()
}

final class RMLocationViewModel: NSObject, RMLocationViewModelDelegate  {
    weak var delegate: RMLocationViewControllerDelegate?

    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    private var apiInfo: RMGetAllLocationsResponse.Info?
    private var cellViewModels: [RMLocationTableViewCellViewModel] = []
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    public var isLoadingMoreLocations = false
    private var didFinishPagination: (() -> Void)?
    private var hasMoreResults: Bool {
        return false
    }

    // MARK: - Actions
    
    func getInstance() -> NSObject & UITableViewDelegate & UITableViewDataSource {
        return self
    }
    
    func setDelegate(_ delegate: RMLocationViewControllerDelegate?) {
        self.delegate = delegate
    }

    func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }

    func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }

    func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest,
                                 expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.apiInfo = model.info
                    self?.locations = model.results
                    DispatchQueue.main.async {
                        self?.delegate?.didFetchInitialLocations()
                    }

                case .failure(let error):
                    //TODO: HANDLE ERROR
                    print(String(describing: error))
            }
        }
    }

    func fetchAddtionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }

        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreLocations = true

        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.apiInfo = info
                    strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({ location in
                        return RMLocationTableViewCellViewModel(location: location)
                    }))
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreLocations = false
                        strongSelf.didFinishPagination?()
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreLocations = false
            }
        }
    }
}

// MARK: - TableView Delegate

extension RMLocationViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let location = self.location(at: indexPath.row) else {
            return
        }
        delegate?.didSelectLocation(location: location)
    }

}

// MARK: - TableView Data Source

extension RMLocationViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViewModels.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }

        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension RMLocationViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !self.cellViewModels.isEmpty,
              self.shouldShowLoadMoreIndicator,
              !self.isLoadingMoreLocations else {
            return
        }


        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.delegate?.showLoadingIndicator()
                self?.fetchAddtionalLocations()
            }
            t.invalidate()
        }
    }

}
