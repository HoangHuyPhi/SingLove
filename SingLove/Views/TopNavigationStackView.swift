//
//  TopNavigationStackView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    let settingButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let chatButton : UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysOriginal), for: .normal)
        return bt
    }()
    
    let fireImageView : UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStackView()
        [settingButton,  fireImageView ,chatButton].forEach { (v) in
            addArrangedSubview(v)
        }
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    private func configureStackView() {
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        distribution = .equalCentering
        axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
}
