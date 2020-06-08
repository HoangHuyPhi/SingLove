//
//  RegistrationViewModel.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/24/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import Firebase


class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>() 
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullName: String? {
        didSet {checkFormValidity()}
    }
    var email: String? {
        didSet {checkFormValidity()}
    }
    var password: String? {
        didSet {checkFormValidity()}
    }
    
    func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil 
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {return}
        self.bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let err = error {
                completion(err)
                return
            }
            self.saveImageToFirebase(completion)
        }
    }
    
    private func saveImageToFirebase(_ completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil) { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            ref.downloadURL { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                self.saveInfoToFireStore(imageUrl: url?.absoluteString ?? "", completion)
                completion(nil)
            }
        }
    }
    
    private func saveInfoToFireStore(imageUrl: String, _ completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String : Any] = ["fullName": fullName ?? "",
                                       "uid" : uid,
                                       "imageUrl1": imageUrl,
                                       "minSeekingAge": UserInfomationViewController.defaultMinSeekingAge,
                                       "maxSeekingAge": UserInfomationViewController.defaultMaxSeekingAge,
                                       "age": 18]
        Firestore.firestore().collection("users").document(uid).setData(docData) {
            err in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
}
