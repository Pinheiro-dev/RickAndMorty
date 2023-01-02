//
//  RMService.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import Foundation

/// Primary API service object to ger Rick and Morty data.
final class RMService {
    /// Shared singleton instace
    static let shared = RMService()

    /// Privatezed constructor
    private init() {}

    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {

    }
}
