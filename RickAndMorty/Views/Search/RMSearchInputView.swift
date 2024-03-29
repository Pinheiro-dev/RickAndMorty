//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 01/02/23.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didChangeSearchText text: String)
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView)
}

/// View for top part of search screen with search bar
final class RMSearchInputView: UIView {

    weak var delegate: RMSearchInputViewDelegate?

    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private var stackView: UIStackView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setUpViews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Private

    private func setUpViews() {
        addSubviews(searchBar)
        searchBar.delegate = self
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58),
        ])
    }

    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        return stackView
    }

    private func createButton(with option: RMSearchInputViewViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        button.setAttributedTitle(
            NSAttributedString(string: option.rawValue,
                               attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                            .foregroundColor: UIColor.label]),
            for: .normal
        )
        button.backgroundColor = .secondarySystemBackground
        button.roundCorners(radius: 10)
        button.tag = tag
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }

    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView
        for index in 0..<options.count {
            let option = options[index]
            let button = createButton(with: option, tag: index)

            stackView.addArrangedSubview(button)
        }
    }

    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }

    // MARK: - Public

    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceHolderText
        self.viewModel = viewModel
    }

    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }

    public func hideKeyboard() {
        searchBar.resignFirstResponder()
    }

    public func update(option: RMSearchInputViewViewModel.DynamicOption, value: String) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else {
                  return
              }

        buttons[index].setAttributedTitle(
            NSAttributedString(string: value.capitalized,
                               attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                            .foregroundColor: UIColor.link]),
            for: .normal
        )
    }
}

// MARK: - UISearchBarDelegate

extension RMSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Execute search
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self)
    }
    
}
