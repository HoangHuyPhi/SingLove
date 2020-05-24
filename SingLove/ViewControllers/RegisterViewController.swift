//
//  ViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/22/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

extension RegisterViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

class RegisterViewController: UIViewController {
    
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
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true 
        return button
    }()
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter email"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.layer.cornerRadius = 16
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleRegister() {
        self.handleTapDismiss()
        guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let err = error {
                print(err)
                self.showHudWithError(err)
                return
            }
            print("Successfully registered user: ", data?.user.uid ?? "")
        }
    }
    
    private func showHudWithError(_ error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    
    let toLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Have an account? Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let registrationViewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGradientLayer()
        setUpUserInformation()
        setUpToLoginButton()
        setUpViewModelRegistration()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    private func setUpViewModelRegistration() {
        registrationViewModel.formValidObserver = { [weak self] (isFormValid) in
            self?.signUpButton.isEnabled = isFormValid
            if isFormValid {
                self?.signUpButton.backgroundColor = .systemBlue
                self?.signUpButton.setTitleColor(.white, for: .normal)
            } else {
                self?.signUpButton.backgroundColor = .lightGray
                self?.signUpButton.setTitleColor(.black, for: .normal)
            }
        }
        registrationViewModel.bindableImage.bind { [weak self] (img) in
        self?.selectPhotoButton.setImage(img, for: .normal)
        }
    }
    
    @objc private func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    @objc private func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    private func setUpUserInformation() {
        setUpStackViewInfo()
        setUpSelectButton()
    }
    
    private func setUpStackViewInfo() {
        let imageStackView = UIStackView(arrangedSubviews: [UIView(), selectPhotoButton, UIView()])
        imageStackView.distribution = .equalCentering
        let stackView = UIStackView(arrangedSubviews: [brandName, imageStackView,fullNameTextField, emailTextField, passwordTextField, signUpButton])
        view.addSubview(stackView)
        stackView.centerInSuperview(size: .init(width: view.frame.width - 100, height: 0))
        stackView.spacing = 10
        stackView.axis = .vertical
    }
    
    private func setUpSelectButton() {
        let constantHeight = view.frame.size.width - 200
        let constandWidth = constantHeight
        selectPhotoButton.constrainHeight(constant: constantHeight)
        selectPhotoButton.constrainWidth(constant: constandWidth)
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

