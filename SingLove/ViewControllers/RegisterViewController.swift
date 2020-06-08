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

class RegisterViewController: UIViewController {
    
    var delegate: LoginControllerDelegate?
    let registeringHUD = JGProgressHUD(style: .dark)
    
    let registerView = RegisteringView()
    private var signUpButton: UIButton! {
        return registerView.signUpButton
    }
    private var selectPhotoButton: UIButton! {
        return registerView.selectPhotoButton
    }
    private var fullNameTextField: UITextField! {
        return registerView.fullNameTextField
    }
    private var emailTextField: UITextField! {
         return registerView.emailTextField
    }
    private var passwordTextField: UITextField! {
          return registerView.passwordTextField
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpViewModelRegistration()
        navigationController?.isNavigationBarHidden = true
        setUpTargets()
    }
    
    private func setUpViews() {
        view.addSubview(registerView)
        registerView.fillSuperview()
        registerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    
    private func setUpTargets() {
        selectPhotoButton.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        registerView.toLoginButton.addTarget(self, action: #selector(handleToLogin), for: .touchUpInside)
        [fullNameTextField, passwordTextField, emailTextField].forEach { (tf) in
            tf?.addTarget(self, action: #selector(handleTextChange(textField:)), for: .editingChanged)
        }
        registerView.signUpButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
    }
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    @objc private func handleToLogin() {
        let loginController = LoginController()
        loginController.delegate = delegate
        navigationController?.pushViewController(loginController, animated: true)
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
    
    @objc private func handleRegister() {
        self.handleTapDismiss()
        registrationViewModel.performRegistration {[weak self] (err) in
            if let err = err {
                self?.showHudWithError(err)
                return
            }
            self?.dismiss(animated: true, completion: {
                self?.delegate?.didFinishLoggingIn()
            })
        }
    }
    
    @objc private func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
// MARK: -- HANDLE TEXT FIELDS
    
    let registrationViewModel = RegistrationViewModel()
    
    private func setUpViewModelRegistration() {
        registrationViewModel.bindableIsFormValid.bind { [weak self] (isFormValid) in
            guard let isFormValid = isFormValid else {
                return
            }
            self?.signUpButton.backgroundColor = isFormValid ? .systemBlue : .lightGray
            self?.signUpButton.setTitleColor(isFormValid ? .white : .black, for: isFormValid ? .normal : .disabled)
            self?.signUpButton.isEnabled = isFormValid
        }
        registrationViewModel.bindableImage.bind { [weak self] (img) in
            self?.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        registrationViewModel.bindableIsRegistering.bind { [weak self] (isRegistering) in
            if isRegistering == true {
                self?.registeringHUD.textLabel.text = "Register"
                self?.registeringHUD.show(in: self?.view ?? UIView())
            } else {
                self?.registeringHUD.dismiss()
            }
        }
    }
    
    private func showHudWithError(_ error: Error) {
        registeringHUD.dismiss()
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
}

// MARK: IMAGE PICKER CONTROLLER METHODS
extension RegisterViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
        registrationViewModel.checkFormValidity()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
}

