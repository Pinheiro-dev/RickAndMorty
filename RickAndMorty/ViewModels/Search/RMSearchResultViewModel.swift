//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/03/23.
//

import Foundation


enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
