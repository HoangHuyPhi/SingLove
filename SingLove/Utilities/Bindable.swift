//
//  Bindable.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/24/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
