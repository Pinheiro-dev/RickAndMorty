//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 03/01/23.
//

import UIKit

/// Controller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    
    private let detailView: RMCharacterDetailView

    // MARK: - Init

    init(viewModel: RMCharacterDetailViewViewModel){
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        setupViews()
        addConstraints()
        detailView.collectionView.delegate = self
        detailView.collectionView.dataSource = self
    }

    @objc
    private func didTapShare() {
        //Share character info
    }

    private func setupViews() {
        view.addSubview(detailView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

// MARK: - CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
            case .photo:
                return 1
            case .information(let viewModel):
                return viewModel.count
            case .episodes(let viewModel):
                return viewModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
            case .photo(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIndetifer,
                    for: indexPath
                ) as? RMCharacterPhotoCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModel)
                return cell
            case .information(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIndetifer,
                    for: indexPath
                ) as? RMCharacterInfoCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModel[indexPath.row])
                return cell
            case .episodes(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                    for: indexPath
                ) as? RMCharacterEpisodeCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: viewModel[indexPath.row])
                return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
            case .photo, .information:
                break
            case .episodes:
                let episodes = self.viewModel.episodes
                let selection = episodes[indexPath.row]
                let vc = RMEpisodeDetailViewController(url: URL(string: selection))
                navigationController?.pushViewController(vc, animated: true)
        }
    }

}
