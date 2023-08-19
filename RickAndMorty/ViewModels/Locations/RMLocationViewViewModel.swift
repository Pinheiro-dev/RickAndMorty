//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 31/01/23.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    weak var delegate: RMLocationViewViewModelDelegate?

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
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    public var isLoadingMoreLocations = false

    // MARK: - Init

    init() {
        
    }

    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }

    public func fetchLocations() {
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

    /// Paginate if additional locations are needed
    public func fetchAddtionalLocations() {
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
                    print("More location: \(moreResults.count)")
                    strongSelf.apiInfo = info
                    strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({ location in
                        return RMLocationTableViewCellViewModel(location: location)
                    }))
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreLocations = false
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreLocations = false
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }
}
