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
    private var searchResultHandler: (() -> Void)?
    private var searchText = ""

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }

    public func set(query text: String) {
        self.searchText = text
    }

    public func executeSearch() {
        print("search text: \(searchText)")

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
        print(request.url?.absoluteString)

        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { result in
            // Notify view of results, no results, or error
            switch result {
                case .success(let model):
                    print("Search results found: \(model.results.count)")
                case .failure(let error):
                    print(String(describing: error))
            }
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
