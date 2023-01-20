//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 13/01/23.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIndetifer = "RMCharacterEpisodeCollectionViewCell"

    private lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()

    private lazy var airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()


    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.roundCorners(radius: 8)
        setUpViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            seasonLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            airDateLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }

    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode " + data.episode
            self?.airDateLabel.text = "Aired on " + data.airDate
        }
        viewModel.fetchEpisode()
    }
}