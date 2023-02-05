//
//  SearchItemSectionView.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 18.05.2022.
//

import Foundation
import UIKit

class SearchItemView: UITableViewCell {
    struct Model {
        var id: Int
        var iconUrl: URL
        var title: String
        var subtitle: String
        
        init(id: Int, iconUrl: URL, title: String, subtitle: String) {
            self.id = id
            self.iconUrl = iconUrl
            self.title = title
            self.subtitle = subtitle
        }
        
        init(_ character: Character) {
            id = character.id
            iconUrl = URL(string: character.image)!
            title = character.name
            subtitle = character.species
        }
    }
    
    init(model: Model) {
//        self.model = model
        super.init(style: .default, reuseIdentifier: Self.defaultReusableIdentifier)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: Model) {
        icon.kf.setImage(with: model.iconUrl)
        title.text = model.title
        subtitle.text = model.subtitle
    }
    
    private func setup() {
        addSubview(icon)
        addSubview(title)
        addSubview(subtitle)
        addSubview(separator)
        
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
        
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 120),
            icon.heightAnchor.constraint(equalToConstant: 160),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 24),
            subtitle.leftAnchor.constraint(equalTo: title.leftAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            separator.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 23),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
        ])
    }

    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.borderWidth = 1
        ret.layer.borderColor = UIColor.main.cgColor
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        return ret
    }()
    private lazy var title: UILabel = {
        let ret = UILabel()
        ret.font = .boldSystemFont(ofSize: 22)
        ret.textColor = .main
        ret.numberOfLines = 2
        return ret
    }()
    private lazy var subtitle: UILabel = {
        let ret = UILabel()
        ret.font = .systemFont(ofSize: 15, weight: .semibold)
        ret.textColor = .secondary
        return ret
    }()
    private lazy var separator: UIView = {
        let ret = UIView()
        ret.backgroundColor = .main
        return ret
    }()
}

extension SearchItemView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
    }
}
