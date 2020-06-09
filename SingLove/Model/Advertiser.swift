//
//  Advertiser.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/13/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let poster: String
    
    func toCardViewModel() -> CardViewModel {
        let atrString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        atrString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        return CardViewModel(imageNames: [poster], attributedString: atrString, textAlignment: .center, uid: "")
    }
}
