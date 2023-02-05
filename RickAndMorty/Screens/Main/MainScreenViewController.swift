//
//  MainScreentViewController.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 21.05.2022.
//

import Foundation
import UIKit

final class MainScreenViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(imageView)
        view.addSubview(closeButton)
        
        view.backgroundColor = .BG
        
        navigationController?.isNavigationBarHidden = true
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        createConstraints()
        NSLayoutConstraint.activate(imageClosedConstraints)
        
        setupTouchRecognizers()
    }
    
    private func createConstraints() {
        imageClosedConstraints = [
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 71),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleLabel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 46),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ]
        
        imageOpenedConstraints = [
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 71),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
        ]
    }
    
    private var imageClosedConstraints: [NSLayoutConstraint] = []
    private var imageOpenedConstraints: [NSLayoutConstraint] = []
    
    private lazy var titleLabel: UILabel = {
        let ret = UILabel()
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : UIColor.main,
            .foregroundColor : UIColor.BG,
            .strokeWidth : 1.0,
            .kern: 3,
            .font: Fonts.blackTitle
            ]
        ret.attributedText = NSAttributedString(string: "RICK \nAND MORTY", attributes: strokeTextAttributes)
        ret.numberOfLines = 3
        
        ret.backgroundColor = .BG
        return ret
    }()
    private lazy var subtitleLabel: UILabel = {
        let ret = UILabel()
        ret.attributedText = NSAttributedString(string: "CHARACTER\nBOOK", attributes: [.kern: 3])
        ret.font = Fonts.blackSubtitle
        ret.numberOfLines = 2
        ret.textColor = .main
        return ret
    }()
    private lazy var imageView: UIImageView = {
        let ret = UIImageView(image: UIImage(named: "DuplicateMainScreenImage"))
        ret.contentMode = .top
        ret.layer.masksToBounds = true
        ret.isUserInteractionEnabled = true
        return ret
    }()
    private lazy var closeButton: UIButton = {
        let ret = Components.closeButton
        ret.alpha = 0
        return ret
    }()
}

extension MainScreenViewController {
    private func setupTouchRecognizers() {
        let imageTouchRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleImageTapGestureRecognizer)
        )
        imageView.addGestureRecognizer(imageTouchRecognizer)
        imageView.isUserInteractionEnabled = true
        
        closeButton.addTarget(self, action: #selector(handleCloseTapGestureRecogniser), for: .touchUpInside)
    }
    
    @objc private func handleImageTapGestureRecognizer() {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.closeButton.alpha = 1
            NSLayoutConstraint.deactivate(self.imageClosedConstraints)
            NSLayoutConstraint.activate(self.imageOpenedConstraints)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handleCloseTapGestureRecogniser() {
        print("now")
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 1
            self.subtitleLabel.alpha = 1
            self.closeButton.alpha = 0
            NSLayoutConstraint.deactivate(self.imageOpenedConstraints)
            NSLayoutConstraint.activate(self.imageClosedConstraints)
            self.view.layoutIfNeeded()
        })
    }
}
