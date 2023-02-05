//
//  SearchViewController.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 26.04.2022.
//

import Combine
import Foundation
import UIKit

final class SearchViewController: UIViewController {

    struct Model {
        var carouselSectionViewModels: Array<CarouselSectionView.Model>
        var searchItemViewModels: Array<SearchItemView.Model>
    }
    
    static func createDefaultModel() -> SearchViewController.Model {
        let model = SearchViewController.Model(carouselSectionViewModels: [
            CarouselSectionView.Model(label: "Recent", itemViewModels: [
                ItemView.Model(id: 1, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!),
                ItemView.Model(id: 2, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!),
                ItemView.Model(id: 3, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")!),
                ItemView.Model(id: 4, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/4.jpeg")!),
            ]),
            CarouselSectionView.Model(label: "Popular", itemViewModels: [
                ItemView.Model(id: 5, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")!),
                ItemView.Model(id: 6, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/6.jpeg")!),
                ItemView.Model(id: 7, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/7.jpeg")!),
                ItemView.Model(id: 8, imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/8.jpeg")!),
            ]),
        ], searchItemViewModels: [
//            SearchItemView.Model(id: 1, iconUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!, title: "Rick\nSanchez", subtitle: "HUMAN"),
//            SearchItemView.Model(id: 2, iconUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")!, title: "Rick\nSanchez", subtitle: "HUMAN")
            
        ])
        return model
    }

    init(storage: LikesStorage, apiClient: APIClient) {
        self.storage = storage
        self.apiClient = apiClient
        model = Self.createDefaultModel()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CarouselSectionView.self, forCellReuseIdentifier: CarouselSectionView.defaultReusableIdentifier)
        tableView.register(SearchItemView.self, forCellReuseIdentifier: SearchItemView.defaultReusableIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        searchBar.sizeToFit()
        searchBar.delegate = self

        view.addSubview(tableView)
        view.backgroundColor = .BG
        tableView.backgroundColor = .BG
        tableView.keyboardDismissMode = .onDrag

        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            searchBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
            searchBar.searchTextField.leftAnchor.constraint(equalTo: searchBar.leftAnchor),
            searchBar.searchTextField.rightAnchor.constraint(equalTo: searchBar.rightAnchor),
            searchBar.searchTextField.topAnchor.constraint(equalTo: searchBar.topAnchor),
            searchBar.searchTextField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateInfo(with model: Model) {
        self.model = model
        tableView.reloadData()
    }

    private let storage: LikesStorage
    private let apiClient: APIClient
    
    private var model: Model
    private var tableViewIsInSearchMode = false

    private let searchBar: UISearchBar = {
        let ret = UISearchBar()
        ret.placeholder = "Search for character"
        ret.backgroundImage = UIImage()
        ret.searchTextField.font = .boldSystemFont(ofSize: 17)
        ret.searchTextField.layer.borderColor = UIColor.main.cgColor
        ret.searchTextField.layer.borderWidth = 2
        ret.searchTextField.layer.cornerRadius = 15
        ret.searchTextField.backgroundColor = .BG
        return ret
    }()
    private let tableView: UITableView = {
        let ret = UITableView()
        ret.separatorStyle = .none
        return ret
    }()
    
    private var pub: AnyPublisher<CharactersSearch, Error>? = nil
    private var sub: Cancellable? = nil
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        navigationController?.pushViewController(CharactersInfoViewController(apiClient: apiClient, storage: self.storage), animated: true)
        if (tableViewIsInSearchMode) {
            navigationController?.pushViewController(CharactersInfoViewController(id: model.searchItemViewModels[indexPath.item].id, apiClient: apiClient, storage: self.storage), animated: true)
        } else {
            print("PANIC PANIC IT SHOULD NOT BE HERE")
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableViewIsInSearchMode) {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchItemView.defaultReusableIdentifier,
                for: indexPath
            ) as? SearchItemView else {
                assertionFailure()
                return UITableViewCell()
            }

            cell.update(with: model.searchItemViewModels[indexPath.item])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CarouselSectionView.defaultReusableIdentifier,
                    for: indexPath
            ) as? CarouselSectionView else {
                assertionFailure()
                return UITableViewCell()
            }

            cell.update(with: model.carouselSectionViewModels[indexPath.item])
            cell.delegate = self

            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableViewIsInSearchMode) {
            return model.searchItemViewModels.count
        } else {
            return model.carouselSectionViewModels.count
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    private func updateSearchData(_ searchItemViewModels: Array<SearchItemView.Model>) {
        model.searchItemViewModels = searchItemViewModels
        tableView.reloadData()
    }
    
    private func updateTableViewMode() {
        tableViewIsInSearchMode = !(searchBar.text?.isEmpty ?? true)
        if (tableViewIsInSearchMode) {
            pub = apiClient.search(query: searchBar.text!)
            sub = pub?.sink(
                receiveCompletion: {completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        print("Finished API search request")
                    }
                },
                receiveValue: {[self] charactersList in
                    self.updateSearchData(charactersList.results.map{SearchItemView.Model($0)})
                }
            )
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateTableViewMode()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateTableViewMode()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateTableViewMode()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateTableViewMode()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateTableViewMode()
    }
}

extension SearchViewController: CarouselSectionViewDelegate {
    func characterClicked(id: Int) {
        navigationController?.pushViewController(CharactersInfoViewController(id: id, apiClient: apiClient, storage: self.storage), animated: true)
    }
}
