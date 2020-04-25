//
//  ViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/22/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        return button
    }()
    
    let firstNameTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter first name"
        return tf
    }()
    
    let lastNameTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter last name"
        return tf
    }()
    
    let emailTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
       let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let signUpButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Sign up", for: .normal)
          button.setTitleColor(.black, for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
          button.layer.cornerRadius = 16
          button.backgroundColor = .white
          button.heightAnchor.constraint(equalToConstant: 50).isActive = true
          return button
      }()
    
    let toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Have an account? Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()
        setUpUserInformation()
        setUpToLoginButton()
    }
    
    private func setUpUserInformation() {
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, signUpButton])
        let secondStackView = UIStackView(arrangedSubviews: [brandName, selectPhotoButton])
        view.addSubview(stackView)
        view.addSubview(secondStackView)
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: view.frame.height / 4, right: 50))
        stackView.spacing = 10
        stackView.axis = .vertical
        secondStackView.spacing = 10
        secondStackView.axis = .vertical
        secondStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: stackView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 100, bottom: 20, right: 100))
        let constantHeight = view.frame.size.width - 200
        selectPhotoButton.constrainHeight(constant: constantHeight)
        selectPhotoButton.layer.cornerRadius = 0.5 * constantHeight
    }
    
    private func setUpToLoginButton() {
        view.addSubview(toLoginButton)
        toLoginButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 40, right: 50))
    }
    
    private func setUpGradientLayer() {
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.1958543658, green: 0.6028831005, blue: 0.9185525179, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8965190053, green: 0, blue: 0.02448023856, alpha: 1)
        gradientLayer.colors = [topColor.cgColor , bottomColor.cgColor]
        gradientLayer.locations = [0.5 , 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
}

