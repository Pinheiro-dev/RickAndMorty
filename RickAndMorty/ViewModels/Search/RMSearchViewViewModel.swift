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
    private var searchText = ""

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func set(query text: String) {
        self.searchText = text
    }

    public func executeSearch() {
        // To do:
        // Create Request based on filters
        // Notify view of results, no results or error

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
