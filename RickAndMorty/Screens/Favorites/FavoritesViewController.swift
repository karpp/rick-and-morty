//
//  FavoritesViewController.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 17.05.2022.
//

import Combine
import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    private let storage: LikesStorage
    private let apiClient: APIClient
    
    struct Model {
        var personModels: Array<ShortPersonView.Model>
    }
    
    static func createDefaultModel() -> Model {
        Model(personModels: [
//            ShortPersonView.Model(id: 1, imageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!, label: "Rick Sanchez"),
//            ShortPersonView.Model(id: 20, imageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/20.jpeg")!, label: "Interdimensional Cable"),
        ])
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
        tableView.register(ShortPersonView.self, forCellReuseIdentifier: ShortPersonView.defaultReusableIdentifier)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        model.personModels = []
        storage.listLikes().forEach{[self, apiClient] characterID in
            uncompletedSubs += 1
            let pub: AnyPublisher<Character, Error> = apiClient.getCharacter(id: characterID)
            let sub = pub
                .sink(
                    receiveCompletion: {[self] completion in
                        self.uncompletedSubs -= 1
                        switch completion {
                        case .failure(let error):
                            print(error)
                        case .finished:
                            print("Finished API request from likes")
                        }
                    },
                    receiveValue: {[self] character in
                        var model = self.model
                        model.personModels.append(ShortPersonView.Model(character))
                        self.update(with: model)
                    }
                )
            self.pubs.append(pub)
            self.subs.append(sub)
            
        }
    }

    func update(with model: Model) {
        self.model = model
        tableView.reloadData()
        
        if (model.personModels.isEmpty) {
            tableView.isHidden = true
            noDataLabel.isHidden = false
        } else {
            tableView.isHidden = false
            noDataLabel.isHidden = true
        }
    }
    
    private func setupUI() {
        view.addSubview(label)
        view.addSubview(tableView)
        view.addSubview(noDataLabel)
        
        if (model.personModels.isEmpty) {
            tableView.isHidden = true
        } else {
            noDataLabel.isHidden = true
        }

        view.backgroundColor = .BG
        tableView.backgroundColor = .BG

        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private var model: Model

    private lazy var label: UILabel = {
        let ret = UILabel()
        ret.text = "Favorites"
        ret.font = Fonts.largeTitle
        ret.textColor = .main
        ret.numberOfLines = 1
        return ret
    }()
    private lazy var noDataLabel: UILabel = {
        let ret = UILabel()
        ret.text = "No favorites yet"
        ret.font = Fonts.title
        ret.textColor = .secondary
        ret.numberOfLines = 1
        return ret
    }()
    private lazy var tableView = UITableView()
    
    private var pubs: [AnyPublisher<Character, Error>] = []
    private var subs: [Cancellable] = []
    private var uncompletedSubs = 0
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("PUSHING CHARACTER VIEWCONTROLLER WITH ID \(model.personModels[indexPath.item].id)")
        navigationController?.pushViewController(CharactersInfoViewController(id: model.personModels[indexPath.item].id, apiClient: apiClient, storage: self.storage), animated: true)
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.personModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ShortPersonView.defaultReusableIdentifier,
                for: indexPath
        ) as? ShortPersonView else {
            assertionFailure()
            return UITableViewCell()
        }

        cell.update(with: model.personModels[indexPath.item])

        return cell
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }


}
