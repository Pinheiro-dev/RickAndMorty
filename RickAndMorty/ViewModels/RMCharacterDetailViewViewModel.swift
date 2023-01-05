//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter

    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }

    public let sections =  SectionType.allCases

    // MARK: - Init

    init(character: RMCharacter) {
        self.character =  character
    }

    private var requestUrl: URL? {
        return URL(string: character.url)
    }

    public var title: String {
        character.name.uppercased()
    }
}
