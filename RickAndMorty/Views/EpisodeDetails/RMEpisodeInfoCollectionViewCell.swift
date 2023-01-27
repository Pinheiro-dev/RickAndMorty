//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 27/01/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setUpLayer()
        setUpViews()
        addContraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private func setUpLayer() {
        roundCorners(radius: 8)
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }

    private func setUpViews() {

    }

    private func addContraints() {

    }

    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {

    }
}
