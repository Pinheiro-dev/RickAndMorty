//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 13/01/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {

    private let imageUrl: URL?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            return completion(.failure(URLError(.badURL)))
        }
        RMImageLoaderManager.shared.downloadImage(imageUrl, completion: completion)
    }

}
