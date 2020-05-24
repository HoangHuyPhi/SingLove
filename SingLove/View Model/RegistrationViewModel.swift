//
//  RegistrationViewModel.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/24/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>() 
    
    var fullName: String? {
        didSet {
            checkFormValidity()
        }
    }
    var email: String? {
        didSet {
            checkFormValidity()
        }
    }
    var password: String? {
        didSet {
            checkFormValidity()
        }
    }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        formValidObserver?(isFormValid)
    }
    
    // Reactice Programming
    var formValidObserver: ((Bool) -> ())?
    
    
}
