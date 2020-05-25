//
//  MainViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 4/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class MainViewController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let bottomStackView = MainBottomControlsStackView()
    let cardsView = UIView()
    var cardViewsModel = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        topStackView.settingButton.addTarget(self, action: #selector(handleSetting), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setUpLayout()
        fetchUsersFromFirestore()
    }
    
    @objc private func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    
    private var lastFetchedUser: User?
    
    
    private func fetchUsersFromFirestore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Finding Matches"
        hud.show(in: view)
        let query = Firestore.firestore().collection("user").order(by: "uuid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch users: ", err)
                return
            }
            snapshot?.documents.forEach({ (docsSnapshot) in
                let userDict = docsSnapshot.data()
                let user = User(dictionary: userDict)
                self.cardViewsModel.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setUpViewCardsFromUsers(user)
            })
        }
    }
    
    private func setUpViewCardsFromUsers(_ user: User) {
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = user.toCardViewModel()
            cardsView.addSubview(cardView)
            cardView.fillSuperview()
    }
    
    @objc private func handleSetting() {
        let loginVC = RegisterViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func setUpViewCards() {
        cardViewsModel.forEach { (card) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = card
            cardsView.addSubview(cardView)
            cardsView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
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
