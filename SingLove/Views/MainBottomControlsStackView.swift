//
//  HomeBottomControlsStackView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class MainBottomControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBottomStackView()
        addButtons()
    }
    
    private func configureBottomStackView() {
        distribution = .fillEqually
        axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func addButtons() {
        let buttons = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { (image) -> UIButton in
            let bt = UIButton(type: .system)
            bt.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            return bt
        }
        
        buttons.forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
