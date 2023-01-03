//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import Foundation
import UIKit

final class RMCharacterListViewViewModel: NSObject {
    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests,
                                 expecting: RMGetAllCharactersResponse.self, completion: { result in
            switch result {
                case .success(let model):
                    print("Example image url: ", model.results.first?.image ?? "no image")
                case .failure(let error):
                    print(String(describing: error))
            }
        })
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            return UICollectionViewCell()
        }

        let viewModel = RMCharacterCollectionViewCellViewModel(characterName: "Pinheiro",
                                                               characterStatus: .unknown,
                                                               characterImageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
        cell.cofigure(with: viewModel)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2

        return CGSize(width: width,
                      height: width * 1.5)
    }

}
