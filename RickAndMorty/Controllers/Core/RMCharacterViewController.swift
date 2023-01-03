//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by mathues barbosa on 02/01/23.
//

import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.title = "Characters"

        let request = RMRequest(endpoint: .character,
                                queryParameters: [
                                    URLQueryItem(name: "name", value: "rick"),
                                    URLQueryItem(name: "status", value: "alive")
                                ])
        print(request.url)
    }
    
}
