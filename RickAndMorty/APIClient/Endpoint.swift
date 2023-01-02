//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import Foundation


/// Represents unique API endpoint
@frozen enum EndPoint: String {
    /// Enpoint to get character info
    case character
    /// Enpoint to get location info
    case location
    /// Enpoint to get episode info
    case espisode
}
