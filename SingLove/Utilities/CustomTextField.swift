//
//  CustomTextField.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/22/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding: CGFloat
    let height: CGFloat
    
    init(padding: CGFloat, height: CGFloat) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = 25
        backgroundColor = .white
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
