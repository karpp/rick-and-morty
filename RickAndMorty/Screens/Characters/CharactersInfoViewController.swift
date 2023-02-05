//
// Created by Egor A. Karpov on 24.04.2022.
//

import Combine
import Foundation
import UIKit
import Kingfisher

final class CharactersInfoViewController: UIViewController {

    struct Model {
        let id: Int
        let statusModels: [InfoCell.Model]
        let name: String
        let imageUrl: URL
        
        init(id: Int, statusModels: [InfoCell.Model], name: String, imageUrl: URL) {
            self.id = id
            self.statusModels = statusModels
            self.name = name
            self.imageUrl = imageUrl
        }
        
        init(_ character: Character) {
            id = character.id
            name = character.name
            imageUrl = URL(string: character.image)!
            statusModels = [
                InfoCell.Model(key: "Status:", value: character.status),
                InfoCell.Model(key: "Species:", value: character.species),
                InfoCell.Model(key: "Gender:", value: character.gender)
            ]
        }
    }
    
    static func createDefaultModel(_ id: Int) -> CharactersInfoViewController.Model {
        let model = CharactersInfoViewController.Model(
            id: id,
            statusModels: [
                InfoCell.Model(key: "Status:", value: "Alive"),
                InfoCell.Model(key: "Species:", value: "Human"),
                InfoCell.Model(key: "Gender:", value: "Male")
            ],
            name: "Abradolf Lincler",
            imageUrl: URL(string: "https://rickandmortyapi.com/api/character/avatar/7.jpeg")!
        )
        return model
    }

    init(id: Int, apiClient: APIClient, storage: LikesStorage) {
        self.model = Self.createDefaultModel(id)
        self.storage = storage
        self.apiClient = apiClient
        
        super.init(nibName: nil, bundle: nil)
        title = "Characters"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BG

        setupUI()
        updateInfo()
        
        pub = self.apiClient.getCharacter(id: model.id)
        sub = pub?.sink(
            receiveCompletion: {completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("Finished API request")
                }
            },
            receiveValue: { [self] character in self.updateModel(with: Model(character)) }
        )
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
    }

    private func setupUI() {
        view.addSubview(icon)
        view.addSubview(titleView)
        titleView.delegate = self
        view.addSubview(charactersInfo)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 300),
            icon.heightAnchor.constraint(equalToConstant: 300),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleView.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 35),
            titleView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            titleView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            titleView.heightAnchor.constraint(equalToConstant: 41),
            charactersInfo.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            charactersInfo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            charactersInfo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateModel(with model: Model) {
        self.model = model
        updateInfo()
    }

    private func updateInfo() {
        icon.kf.setImage(with: model.imageUrl)
        titleView.update(with: model.name, liked: self.isLiked())
        charactersInfo.update(with: model.statusModels)
    }
    
    private func isLiked() -> Bool {
        return storage.isLiked(id: model.id)
    }

    private let storage: LikesStorage
    private let apiClient: APIClient
    
    private var model: Model
    
    private var pub: AnyPublisher<Character, Error>? = nil
    private var sub: Cancellable? = nil

    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        ret.layer.borderWidth = 1
        ret.layer.borderColor = UIColor.main.cgColor
        return ret
    }()
    private lazy var titleView = TitleView()
    private lazy var charactersInfo = CharacterInfoView(cellCount: 3)
}

extension CharactersInfoViewController: TitleViewDelegate {
    func likeButtonPressed(state isLiked: Bool) {
        if (isLiked) {
            storage.like(id: model.id)
        } else {
            storage.dislike(id: model.id)
        }
    }
}
