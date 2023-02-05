//
// Created by Egor A. Karpov on 10.05.2022.
//

import Foundation
import UIKit

final class CarouselSectionView: UITableViewCell {

    struct Model {
        var label: String
        var itemViewModels: Array<ItemView.Model>
    }

    init(model: Model) {
        self.model = model
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
        titleLabel.text = model.label
        collectionView.reloadData()
        self.model = model
    }

    private func setup() {
        backgroundColor = .BG

        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.backgroundColor = .BG

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemView.self, forCellWithReuseIdentifier: ItemView.defaultReusableIdentifier)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private var model = Model(label: "Recent", itemViewModels: [])

    private let titleLabel: UILabel = {
        let rec = UILabel()
        rec.font = .boldSystemFont(ofSize: 17)
        rec.textColor = .main
        return rec
    }()

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 160)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let ret = UICollectionView(frame: .zero, collectionViewLayout: layout)
        ret.backgroundColor = .BG
        return ret
    }()
    
    var delegate: CarouselSectionViewDelegate? = nil
}

extension CarouselSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.characterClicked(id: model.itemViewModels[indexPath.item].id)
    }
}

extension CarouselSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.itemViewModels.count
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ItemView.defaultReusableIdentifier,
                for: indexPath
        ) as? ItemView else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.update(with: model.itemViewModels[indexPath.item])
        return cell
    }
}

protocol CarouselSectionViewDelegate {
    func characterClicked(id: Int)
}

final class ItemView: UICollectionViewCell {
    struct Model {
        let id: Int
        let imageURL: URL?
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
        icon.kf.setImage(with: model.imageURL)
    }

    func setup() {
        contentView.addSubview(icon)
        contentView.backgroundColor = .BG
        
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }

        icon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: contentView.topAnchor),
            icon.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            icon.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private lazy var icon: UIImageView = {
        let ret = UIImageView()
        ret.layer.cornerRadius = 10
        ret.layer.masksToBounds = true
        ret.contentMode = .scaleAspectFill
        ret.layer.borderWidth = 1
        ret.layer.borderColor = UIColor.main.cgColor
        return ret
    }()

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if (traitCollection.userInterfaceStyle == .dark) {
            icon.layer.borderWidth = 0
        } else {
            icon.layer.borderWidth = 1
        }
    }
}

extension UITableViewCell {
    static var defaultReusableIdentifier: String {
        String(describing: Self.self)
    }
}

extension UICollectionViewCell {
    static var defaultReusableIdentifier: String {
        String(describing: Self.self)
    }
}
