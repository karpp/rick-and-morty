//
//  Buttons.swift
//  RickAndMorty
//
//  Created by Egor A. Karpov on 25.04.2022.
//

import Foundation
import UIKit

struct Components {
    public static let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .greyBG
        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.main, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 24
        return button
    }()
}
