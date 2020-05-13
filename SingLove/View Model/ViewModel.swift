//
//  ViewModel.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/13/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    
    let imageName: String
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    
    
}


