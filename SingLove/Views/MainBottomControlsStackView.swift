//
//  HomeBottomControlsStackView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class MainBottomControlsStackView: UIStackView {
    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "refresh_circle"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "boost_circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBottomStackView()
    }
    
    private func configureBottomStackView() {
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        [refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { (bt) in
            self.addArrangedSubview(bt)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
