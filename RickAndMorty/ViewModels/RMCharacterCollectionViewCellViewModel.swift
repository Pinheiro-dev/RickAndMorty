//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import Foundation
import UIKit

final class RMCharacterCollectionViewCellViewModel {
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageUrl: URL?

    // MARK: - Init

    init(characterName: String,
         characterStatus: RMCharacterStatus,
         characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }

    public var characterStatusText: String {
        return characterStatus.text
    }

    public var characterStatusColor: UIColor {
        return characterStatus.color
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoaderManager.shared.downloadImage(url, completion: completion)
    }

}

// MARK: - Hashable

extension RMCharacterCollectionViewCellViewModel:  Hashable, Equatable {
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
