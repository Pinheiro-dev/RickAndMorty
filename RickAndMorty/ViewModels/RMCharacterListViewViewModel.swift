//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class RMCharacterListViewViewModel: NSObject {

    public weak var delegate: RMCharacterListViewViewModelDelegate?

    private var characters: [RMCharacter] = [] {
        didSet {
            characters.forEach({ character in
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                                       characterStatus: character.status,
                                                                       characterImageUrl: URL(string: character.image))
                cellViewModels.append(viewModel)
            })
        }
    }

    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []

    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests,
                                 expecting: RMGetAllCharactersResponse.self,
                                 completion: { [weak self] result in
            switch result {
                case .success(let responseModel):
                    let results = responseModel.results
                    let info = responseModel.info
                    self?.characters = results
                    DispatchQueue.main.async {
                        self?.delegate?.didLoadInitialCharacters()
                    }
                case .failure(let error):
                    print(String(describing: error))
            }
        })
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.cofigure(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2

        return CGSize(width: width,
                      height: width * 1.5)
    }

}
