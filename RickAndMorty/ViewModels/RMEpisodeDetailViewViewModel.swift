//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 20/01/23.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetals()
}

final class RMEpisodeDetailViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetals()
        }
    }

    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?

    // MARK: - Init

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }

    // MARK: - Public

    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }

        RMService.shared.execute(request,
                                 expecting: RMEpisode.self) { [weak self] result in
            switch result {
                case .success(let model):
                    self?.fetchRelatedCharacters(episode: model)
                case .failure(let failure):
                    print(String(describing: failure))
            }
        }
    }

    // MARK: - Private
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })

        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }

                switch result {
                    case .success(let model):
                        characters.append(model)
                    case .failure:
                        break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }
}
