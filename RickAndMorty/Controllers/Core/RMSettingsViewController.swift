//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import StoreKit
import SafariServices
import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {

    private lazy var settingsSwiftUIController: UIHostingController<RMSettingsView> = {
        let controller = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewModel(type: $0) { [weak self] option in
                            self?.handleTap(option: option)
                        }
                    })
                )
            )
        )
        controller.didMove(toParent: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Settings"
        addSwiftUIController()
        setUpViews()
        addConstraints()
    }

    private func addSwiftUIController() {
        addChild(settingsSwiftUIController)
    }

    private func setUpViews() {
        view.addSubview(settingsSwiftUIController.view)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }

        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }

}
