//
//  RMCharacterCollectionViewCell.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import UIKit

/// Single call for a character
final class RMCharacterCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

     private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statusView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .secondarySystemBackground
        self.setupViews()
        self.addConstraints()
        self.setupLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setupViews() {
        self.contentView.addSubviews(imageView, nameLabel, statusView, statusLabel)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            statusView.heightAnchor.constraint(equalToConstant: 10),
            statusView.widthAnchor.constraint(equalToConstant: 10),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),

            statusView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            statusLabel.leftAnchor.constraint(equalTo: statusView.rightAnchor, constant: 5),
            statusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),

            statusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
            statusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
        ])
    }

    private func setupLayer() {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowColor = UIColor.label.cgColor
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.shadowOffset = CGSize(width: -4, height: 4)
        self.contentView.layer.shadowOpacity = 0.2
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupLayer()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.nameLabel.text = nil
        self.statusLabel.text = nil
    }

    public func cofigure(with viewModel: RMCharacterCollectionViewCellViewModel) {
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatusText
        statusView.backgroundColor = viewModel.characterStatusColor
        viewModel.fetchImage { [weak self] result in
            switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self?.imageView.image = image
                    }
                case .failure(let error):
                    print(String(describing: error))
                    break
            }
        }
    }


}
