//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 29/01/23.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode

    var displayTitle: String {
        switch self {
            case .rateApp:
                return "Rate App"
            case .contactUs:
                return "Contact Us"
            case .terms:
                return "Terms of Services"
            case .privacy:
                return "Privacy Policy"
            case .apiReference:
                return "API Reference"
            case .viewSeries:
                return "View Video Series"
            case .viewCode:
                return "View App code"
        }
    }

    var iconContainerColor: UIColor {
        switch self {
            case .rateApp:
                return .systemBlue
            case .contactUs:
                return .systemGreen
            case .terms:
                return .systemRed
            case .privacy:
                return .systemYellow
            case .apiReference:
                return .systemOrange
            case .viewSeries:
                return .systemPurple
            case .viewCode:
                return .systemPink
        }
    }

    var iconImage: UIImage? {
        switch self {
            case .rateApp:
                return UIImage(systemName: "star.fill")
            case .contactUs:
                return UIImage(systemName: "paperplane")
            case .terms:
                return UIImage(systemName: "doc")
            case .privacy:
                return UIImage(systemName: "lock")
            case .apiReference:
                return UIImage(systemName: "bookmark.square")
            case .viewSeries:
                return UIImage(systemName: "tv")
            case .viewCode:
                return UIImage(systemName: "chevron.left.forwardslash.chevron.right")
        }
    }
}
