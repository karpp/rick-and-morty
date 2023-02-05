//
// Created by Egor A. Karpov on 24.04.2022.
//

import UIKit

final class InfoCell: UIView {

    struct Model {
        let key: String
        let value: String
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        infoKeyLabel.text = model.key
        infoValueLabel.text = model.value
    }

    private func setup() {
        addSubview(infoKeyLabel)
        addSubview(infoValueLabel)
        addSubview(separator)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            infoKeyLabel.topAnchor.constraint(equalTo: topAnchor),
            infoKeyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoKeyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoValueLabel.topAnchor.constraint(equalTo: infoKeyLabel.bottomAnchor),
            infoValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.topAnchor.constraint(equalTo: infoValueLabel.bottomAnchor, constant: 8),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leftAnchor.constraint(equalTo: leftAnchor),
            separator.rightAnchor.constraint(equalTo: rightAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private let infoKeyLabel: UILabel = {
        let ret = UILabel()
        ret.font = Fonts.title
        ret.textColor = .secondary
        ret.numberOfLines = 1
        return ret
    }()

    private let infoValueLabel: UILabel = {
        let ret = UILabel()
        ret.font = Fonts.title
        ret.textColor = .main
        ret.numberOfLines = 1
        return ret
    }()
    
    private let separator: UIView = {
        let ret = UIView()
        ret.backgroundColor = .main
        return ret
    }()
}

final class CharacterInfoView: UIView {
    override init(frame: CGRect) {
        var cells: [InfoCell] = []
        for _ in 0..<3 {
            cells.append(InfoCell())
        }
        self.infoCells = cells
        super.init(frame: frame)
        setup()
        
    }
    
    init(cellCount: Int) {
        var cells: [InfoCell] = []
        for _ in 0..<cellCount {
            cells.append(InfoCell())
        }
        self.infoCells = cells
        super.init()
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with models: [InfoCell.Model]) {
        assert(infoCells.count == models.count)
        for i in 0..<infoCells.count {
            infoCells[i].update(with: models[i])
        }
    }
    
    private func setup() {
        let stack = UIStackView()
        addSubview(stack)
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.contentMode = .left
        stack.axis = .vertical
        stack.spacing = 16
        
        infoCells.forEach {
            stack.addArrangedSubview($0)
        }
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private let infoCells: [InfoCell]
}

final class TitleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(nameLabel)
        addSubview(likeButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeButton.rightAnchor.constraint(equalTo: rightAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 48),
            likeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func update(with name: String, liked: Bool) {
        nameLabel.text = name
        isLikeButtonPressed = liked
        self.updateLikeButton()
    }
    
    private func updateLikeButton() {
        if (!isLikeButtonPressed) {
            likeButton.backgroundColor = .greyBG
            likeButton.setImage(UIImage(systemName: "heart")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            likeButton.backgroundColor = .main
            likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.BG, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    let nameLabel: UILabel = {
        let ret = UILabel()
        ret.font = Fonts.largeTitle
        ret.textColor = .main
        ret.numberOfLines = 1
        return ret
    }()

    let likeButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .greyBG
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 24
        return button
    }()
    
    private var isLikeButtonPressed = false
    public var delegate: TitleViewDelegate?
}

extension TitleView {
    
    @objc private func likeButtonPress() {
        isLikeButtonPressed = !isLikeButtonPressed
        self.updateLikeButton()
        self.delegate?.likeButtonPressed(state: isLikeButtonPressed)
    }
}

protocol TitleViewDelegate {
    func likeButtonPressed(state isLiked: Bool)
}
