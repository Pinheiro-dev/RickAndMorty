//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 06/03/23.
//

import UIKit

/// Shows search results UI (table or collection as needed)
final class RMSearchResultView: UIView {

    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self,
                       forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setUpViews() {
        addSubviews(tableView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        tableView.backgroundColor = .yellow
    }

    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }

        switch viewModel {
            case .characters(let viewModels):
                setUpCollectionView()
            case .episodes(let viewModels):
                setUpCollectionView()
            case .locations(let viewModels):
                setUpTableView()
        }
    }

    private func setUpCollectionView() {

    }

    private func setUpTableView() {
        tableView.isHidden = false
    }

    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }

}
