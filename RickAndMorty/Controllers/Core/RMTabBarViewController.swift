//
//  RMTabBarViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class RMTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.setUpTabViewControllers()
    }

    private func setUpTabViewControllers() {
        let chartacterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()

        chartacterVC.navigationItem.largeTitleDisplayMode = .automatic
        locationVC.navigationItem.largeTitleDisplayMode = .automatic
        episodeVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic

        let chartacterNavigation = UINavigationController(rootViewController: chartacterVC)
        let locationNavigation = UINavigationController(rootViewController: locationVC)
        let episodeNavigation = UINavigationController(rootViewController: episodeVC)
        let settingsNavigation = UINavigationController(rootViewController: settingsVC)

        chartacterNavigation.tabBarItem = UITabBarItem(title: "Characters",
                                                       image: UIImage(systemName: "person.text.rectangle"),
                                                       tag: 1)

        locationNavigation.tabBarItem = UITabBarItem(title: "Locations",
                                                       image: UIImage(systemName: "globe"),
                                                       tag: 2)

        episodeNavigation.tabBarItem = UITabBarItem(title: "Episodes",
                                                       image: UIImage(systemName: "tv"),
                                                       tag: 3)

        settingsNavigation.tabBarItem = UITabBarItem(title: "Settings",
                                                       image: UIImage(systemName: "gear"),
                                                       tag: 4)

        let navigationsController: [UINavigationController] = [chartacterNavigation,
                                                               locationNavigation,
                                                               episodeNavigation,
                                                               settingsNavigation]

        navigationsController.forEach{ navigation in
            navigation.navigationBar.prefersLargeTitles = true
        }

        self.setViewControllers(navigationsController, animated: true)
    }

}

