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

class MainViewController: UIViewController, CardViewDelegate , UserInfomationDelegate{
    
    let topStackView = TopNavigationStackView()
    let bottomStackView = MainBottomControlsStackView()
    let cardsView = UIView()
    var cardViewModels = [CardViewModel]()
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(presentInfoViewController), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        setUpLayout()
        
        fetchCurrentUser()
        print("lol")
        //fetchUsersFromFirestore()
        //setupFirestoreUserCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser == nil {
            let registrationController = RegisterViewController()
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else {
                return
            }
            self.user = User(dictionary: dictionary)
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc private func handleRefresh() {
        fetchUsersFromFirestore()
    }
    
    
    private var lastFetchedUser: User?
    
    
    private func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Finding Matches"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch users: ", err)
                return
            }
            snapshot?.documents.forEach({ (docsSnapshot) in
                let userDict = docsSnapshot.data()
                let user = User(dictionary: userDict)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setUpViewCardsFromUsers(user)
            })
        }
    }
    
    private func setUpViewCardsFromUsers(_ user: User) {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setupFirestoreUserCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    
    @objc private func presentInfoViewController() {
        let userInfo = UserInfomationViewController()
        userInfo.delegate = self
        let navigationUserInfo = UINavigationController(rootViewController: userInfo)
        navigationUserInfo.modalPresentationStyle = .fullScreen
        present(navigationUserInfo, animated: true)
    }
    
    private func setUpLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsView, bottomStackView])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor , bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        stackView.bringSubviewToFront(cardsView)
        view.backgroundColor = .white
    }
    
    func didSaveInfo() {
        fetchCurrentUser()
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel!) {
        print("Home Controller: ", cardViewModel.attributedString)
        let userDetailsController = UserDetailViewController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
    
}
