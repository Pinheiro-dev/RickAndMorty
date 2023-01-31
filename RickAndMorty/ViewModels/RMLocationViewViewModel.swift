//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 31/01/23.
//

import Foundation

final class RMLocationViewViewModel {

    private var locations: [RMLocation] = []

    private var cellViewModels: [String] = []

    init() {
        
    }

    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest,
                                 expecting: RMLocation.self) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.locations.append(model)
                case .failure(let failure):
                    print(String(describing: failure))
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }
}
