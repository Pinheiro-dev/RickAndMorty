//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 13/01/23.
//

import UIKit
import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {

    private let type: `Type`
    private let value: String

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()

    public var title: String {
        return type.displayTitle
    }

    public var displayValue: String {
        if value.isEmpty { return "None" }

        if let date = Self.dateFormatter.date(from: value),
           type == .created {
            return Self.shortDateFormatter.string(from: date)
        }

        return value
    }

    public var iconImage: UIImage? {
        return type.iconImage
    }

    public var tintColor: UIColor {
        return type.tintColor
    }

    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount

        var tintColor: UIColor {
            switch self {
                case .status:
                    return .systemBlue
                case .gender:
                    return .systemRed
                case .type:
                    return .systemPurple
                case .species:
                    return .systemGreen
                case .origin:
                    return .systemOrange
                case .location:
                    return .systemPink
                case .created:
                    return .systemYellow
                case .episodeCount:
                    return .systemMint
            }
        }

        var iconImage: UIImage? {
            switch self {
                case .status:
                    return UIImage(systemName: "heart.text.square")
                case .gender:
                    return UIImage(systemName: "person")
                case .type:
                    return UIImage(systemName: "t.circle")
                case .species:
                    return UIImage(systemName: "atom")
                case .origin:
                    return UIImage(systemName: "globe.americas")
                case .location:
                    return UIImage(systemName: "mappin.and.ellipse")
                case .created:
                    return UIImage(systemName: "calendar")
                case .episodeCount:
                    return UIImage(systemName: "tv")
            }
        }

        var displayTitle: String {
            switch self {
                case .status,
                    .gender,
                    .type,
                    .species,
                    .origin,
                    .location,
                    .created:
                    return rawValue.capitalized
                case .episodeCount:
                    return "Total episodes"

            }
        }

    }

    init(type: `Type`, value: String) {
        self.type = type
        self.value = value

    }
}
