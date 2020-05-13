//
//  MainViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let bottomStackView = MainBottomControlsStackView()
    let cardsView = UIView()
    
    let cardViewModels : [CardViewModel] = {
        let producer = [
              User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
              User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c"),
              Advertiser(title: "Slide out Menu", brandName: "Let's build that app", poster: "slide_out_menu_poster")
        ] as [ProducesCardViewModel]
        
        let viewModels = producer.map { (card) -> CardViewModel in
            return card.toCardViewModel()
        }
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpLayout()
        setUpDummyCards()
        
    }
    
    private func setUpDummyCards() {
        cardViewModels.forEach { (card) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = card
            cardsView.addSubview(cardView)
        }
    }
    
    private func setUpLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsView, bottomStackView])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stackView.bringSubviewToFront(cardsView)
    }
    
}
