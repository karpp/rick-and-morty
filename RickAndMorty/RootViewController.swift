//
//  RootViewController.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 11.05.2022.
//

import Foundation
import UIKit

final class RootViewController: UITabBarController {
    
    let storage: LikesStorage
    let apiClient: APIClient
    
    init(storage: LikesStorage, apiClient: APIClient) {
        self.storage = storage
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
            createMain(),
            createFavorites(),
            createSearch(),
        ]
    }
    
    func createSearch() -> UINavigationController {
        let ret = UINavigationController(rootViewController: SearchViewController(storage: storage, apiClient: apiClient))
        ret.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "magnifyingglass")?.withTintColor(.main, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "magnifyingglass")?.withTintColor(.main, renderingMode: .alwaysOriginal))
        return ret
    }

    func createFavorites() -> UINavigationController {
        let ret = UINavigationController(rootViewController: FavoritesViewController(storage: storage, apiClient: apiClient))
        ret.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "heart")?.withTintColor(.main, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "heart.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal))
        return ret
    }
    
    func createMain() -> UINavigationController {
        let ret = UINavigationController(rootViewController: MainScreenViewController())
        ret.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house")?.withTintColor(.main, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "house.fill")?.withTintColor(.main, renderingMode: .alwaysOriginal))
        return ret
    }
}
