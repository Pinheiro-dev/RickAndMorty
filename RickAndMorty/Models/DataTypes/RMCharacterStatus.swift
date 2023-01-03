//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"

    var text: String {
        switch self {
            case .alive, .dead:
                return rawValue
            case .unknown:
                return "Unknown"
        }
    }

    var color: UIColor {
        switch self {
            case .alive:
                return .systemGreen
            case .dead:
                return .systemRed
            case .unknown:
                return .systemGray
        }
    }
}
