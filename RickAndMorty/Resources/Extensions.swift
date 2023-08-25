//
//  Extensions.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            self.addSubview($0)
        })
    }

    func roundCorners(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
        var maskedCorners: CACornerMask = .init()
        corners.forEach({ corner in
            switch corner {
                case .topLeft:
                    maskedCorners.insert(.layerMinXMinYCorner)
                case .topRight:
                    maskedCorners.insert(.layerMaxXMinYCorner)
                case .bottomLeft:
                    maskedCorners.insert(.layerMinXMaxYCorner)
                case .bottomRight:
                    maskedCorners.insert(.layerMaxXMaxYCorner)
                default:
                    break
            }
        })

        self.layer.cornerRadius = radius
        if !maskedCorners.isEmpty {
            self.layer.maskedCorners = maskedCorners
        }
    }
}

extension UIDevice {
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}
