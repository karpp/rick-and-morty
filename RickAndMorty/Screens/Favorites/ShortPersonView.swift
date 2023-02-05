//
//  ShortPersonView.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 17.05.2022.
//

import Foundation
import UIKit

final class ShortPersonView: UITableViewCell {
    struct Model {
        var id: Int
        var imageUrl: URL
        var label: String
        
        init(id: Int, imageUrl: URL, label: String) {
            self.id = id
            self.imageUrl = imageUrl
            self.label = label
        }
        
        init(_ character: Character) {
            id = character.id
            imageUrl = URL(string: character.image)!
            label = character.name
        }
    }
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    init() {
        super.init(style: .default, reuseIdentifier: Self.defaultReusableIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: Model) {
        icon.kf.setImage(with: model.imageUrl)
        label.text = model.label
    }
    
    private func setup() {
        backgroundColor = .BG
        
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
        
        addSubview(icon)
        addSubview(label)
        addSubview(separator)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            icon.heightAnchor.constraint(equalToConstant: 100),
            icon.widthAnchor.constraint(equalToConstant: 100),
            label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 24),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 52),
            label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16),
            separator.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 23),
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        ret.layer.borderWidth = 1
        ret.layer.borderColor = UIColor.main.cgColor
        return ret
    }()
    
    private let label: UILabel = {
        let ret = UILabel()
        ret.font = Fonts.title
        ret.textColor = .main
        return ret
    }()
    
    private let separator: UIView = {
        let ret = UIView()
        ret.backgroundColor = .main
        return ret
    }()
}

extension ShortPersonView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
    }
}
