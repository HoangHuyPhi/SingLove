//
//  LoginController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 6/8/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoginControllerDelegate {
    func didFinishLoggingIn()
}

class LoginController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    
    let brandName: UILabel = {
         let lb = UILabel()
         lb.text = "SingLove"
         lb.textColor = UIColor.white
         lb.font = UIFont.systemFont(ofSize: 30, weight: .light)
         lb.textAlignment = .center
         return lb
     }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 50)
        tf.placeholder = "Enter Email"
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
          let tf = CustomTextField(padding: 24, height: 50)
          tf.placeholder = "Enter Password"
          tf.isSecureTextEntry = true
          tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
          return tf
    }()
    
    let  loginButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("Login", for: .normal)
         button.setTitleColor(.black, for: .disabled)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
         button.layer.cornerRadius = 16
         button.backgroundColor = .lightGray
         button.isEnabled = false
         button.heightAnchor.constraint(equalToConstant: 50).isActive = true
         button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
         return button
     }()
    
    let toRegisterButton: UIButton = {
         let button = UIButton(type: .system)
         button.setTitle("Don't have an account? Go to Register", for: .normal)
         button.setTitleColor(.white, for: .normal)
         button.addTarget(self, action: #selector(handleToRegister), for: .touchUpInside)
         return button
     }()
    
    private let loginViewModel = LoginViewModel()
    private let loginHUD = JGProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        setUpGradientLayer()
        setUpStackViewInfo()
        setUpToLoginButton()
        setupBindables()
    }
    
    @objc private func handleTapDismiss() {
        view.endEditing(true)
    }
    
    fileprivate func setupBindables() {
        loginViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.loginButton.isEnabled = isFormValid
            self.loginButton.backgroundColor = isFormValid ? .systemBlue : .lightGray
            self.loginButton.setTitleColor(isFormValid ? .white : .black, for: isFormValid ? .normal : .disabled)
        }
        loginViewModel.isLoggingIn.bind { [unowned self] (isRegistering) in
            if isRegistering == true {
                self.loginHUD.textLabel.text = "Register"
                self.loginHUD.show(in: self.view)
            } else {
                self.loginHUD.dismiss()
            }
        }
    }
    
    private func setUpStackViewInfo() {
        let stackView = UIStackView(arrangedSubviews: [brandName, UIView() ,emailTextField, passwordTextField, loginButton])
        view.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: view.frame.width - 100, height: 0))
        stackView.spacing = 10
        stackView.axis = .vertical
    }
    
    private func setUpToLoginButton() {
        view.addSubview(toRegisterButton)
        toRegisterButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 40, right: 50))
    }
    
    @objc private func handleTextChange(textField: UITextField) {
        if textField == emailTextField {
            loginViewModel.email = textField.text
        } else {
            loginViewModel.password = textField.text
        }
    }
    
    @objc private func handleLogin() {
        loginViewModel.performLogin { (err) in
            self.loginHUD.dismiss()
            if let err = err {
                print("Failed to log in:", err)
                return
            }
            print("Logged in successfully")
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    @objc private func handleToRegister() {
        navigationController?.popViewController(animated: true)
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
