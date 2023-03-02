//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import Foundation

final class RMSearchViewViewModel {
    public let config: RMSearchViewController.Config

    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    private var searchText = ""

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func set(query text: String) {
        self.searchText = text
    }

    public func executeSearch() {
        // Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]

        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key = element.key
            let value = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Create request
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)

        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }

    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request,
                                 expecting: type) { [weak self] result in
            // Notify view of results, no results, or error
            switch result {
                case .success(let model):
                    self?.processSearchResults(model: model)
                case .failure(let error):
                    print(String(describing: error))
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultVM: RMSearchResultViewModel?
        if let charactersResults = model as? RMGetAllCharactersResponse {
            resultVM = .characters(charactersResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                              characterStatus: $0.status,
                                                              characterImageUrl: URL(string: $0.image))
            }))
        } else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        } else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }

        if let results = resultVM {
            self.searchResultHandler?(results)
        } else {
            // Fallback error
        }

    }

    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }

}
