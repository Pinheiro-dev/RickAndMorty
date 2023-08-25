//
//  RMLocationDetailView.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import UIKit

protocol RMLocationDetailViewDelegate: AnyObject {
    func rmLocationDetailView(_ detailView: RMLocationDetailView,
                             didSelectCharacter character: RMCharacter)
}

final class RMLocationDetailView: UIView {

    public weak var delegate: RMLocationDetailViewDelegate?

    private var viewModel: RMLocationDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            collectionView.reloadData()
            collectionView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
        }
    }

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.layout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setUpViews()
        addConstraints()

        spinner.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        addSubviews(collectionView, spinner)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public

    public func configure(with viewModel: RMLocationDetailViewViewModel) {
        self.viewModel = viewModel
    }

}

extension RMLocationDetailView {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        switch sections[section] {
            case .informations:
                return createInfoLayout()
            case .characters:
                return createCharacterLayout()
        }

    }

    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))

        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 10,
                                                     bottom: 10,
                                                     trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)
            ),
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 5,
                                                     leading: 10,
                                                     bottom: 5,
                                                     trailing: UIDevice.isIphone ? 5 : 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.9 : 1.0),
                heightDimension: .absolute(UIDevice.isIphone ? 260 : 320)
            ),
            subitems: UIDevice.isIphone ? [item] : [item, item, item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior =  UIDevice.isIphone ? .groupPaging : .none
        return section
    }
}

extension RMLocationDetailView: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType {
            case .informations(let viewModels):
                return viewModels.count
            case .characters(let viewModels):
                return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let sections = viewModel?.cellViewModels else {
            return UICollectionViewCell()
        }
        let sectionType = sections[indexPath.section]
        switch sectionType {
            case .informations(let viewModels):
                let cellViewModel = viewModels[indexPath.row]
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as? RMEpisodeInfoCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: cellViewModel)
                return cell
            case .characters(let viewModels):
                let cellViewModel = viewModels[indexPath.row]
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as? RMCharacterCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: cellViewModel)
                return cell
        }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let viewModel = viewModel else {
            return
        }
        let sections = viewModel.cellViewModels

        let sectionType = sections[indexPath.section]
        switch sectionType {
            case .informations:
                break
            case .characters:
                guard let character = viewModel.character(at: indexPath.row) else {
                    return
                }
                delegate?.rmLocationDetailView(self, didSelectCharacter: character)
        }
    }

}

