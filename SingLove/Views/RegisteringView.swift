//
//  RegisteringView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 6/8/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class RegisteringView: UIView {
    
    let brandName: UILabel = {
        let lb = UILabel()
        lb.text = "SingLove"
        lb.textColor = UIColor.white
        lb.font = UIFont.systemFont(ofSize: 30, weight: .light)
        lb.textAlignment = .center
        return lb
    }()
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.8727399707, green: 0.8807931542, blue: 0.900990963, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter full name"
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter email"
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.black, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 16
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    let toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Have an account? Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpGradientLayer()
        setUpUserInformation()
        setUpToLoginButton()
    }
    private func setUpUserInformation() {
        setUpStackViewInfo()
        setUpSelectButton()
    }
    
    private func setUpStackViewInfo() {
        let imageStackView = UIStackView(arrangedSubviews: [UIView(), selectPhotoButton, UIView()])
        imageStackView.distribution = .equalCentering
        let stackView = UIStackView(arrangedSubviews: [brandName, imageStackView,fullNameTextField, emailTextField, passwordTextField, signUpButton])
        addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: frame.width - 100, height: 0))
        stackView.spacing = 10
        stackView.axis = .vertical
    }
    
    private func setUpSelectButton() {
        let constantHeight = frame.size.width - 200
        let constandWidth = constantHeight
        selectPhotoButton.constrainHeight(constant: constantHeight)
        selectPhotoButton.constrainWidth(constant: constandWidth)
        selectPhotoButton.layer.cornerRadius = 0.5 * constantHeight
    }
    
    private func setUpToLoginButton() {
        addSubview(toLoginButton)
        toLoginButton.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 50, bottom: 40, right: 50))
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.1958543658, green: 0.6028831005, blue: 0.9185525179, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8965190053, green: 0, blue: 0.02448023856, alpha: 1)
        gradientLayer.colors = [topColor.cgColor , bottomColor.cgColor]
        gradientLayer.locations = [0.5 , 1]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }
    
    
}
