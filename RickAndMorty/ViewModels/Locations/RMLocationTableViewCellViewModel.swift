//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import Foundation

struct RMLocationTableViewCellViewModel {

    private let location: RMLocation

    init(location: RMLocation) {
        self.location = location
    }

    public var name: String {
        return location.name
    }

    public var type: String {
        return location.type
    }

    public var dimesion: String {
        return location.dimension
    }

}

// MARK: - Hashable

extension RMLocationTableViewCellViewModel: Hashable, Equatable{
        static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
            return lhs.location.id == rhs.location.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(location.id)
        }

}
