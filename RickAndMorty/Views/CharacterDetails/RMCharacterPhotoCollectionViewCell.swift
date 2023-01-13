//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 13/01/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let cellIndetifer = "RMCharacterPhotoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        
    }

    private func addConstraints() {

    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {

    }
}
