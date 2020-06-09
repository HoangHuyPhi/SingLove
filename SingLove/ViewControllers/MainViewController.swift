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

class MainViewController: UIViewController, CardViewDelegate , UserInfomationDelegate, LoginControllerDelegate {

    let topStackView = TopNavigationStackView()
    let bottomStackView = MainBottomControlsStackView()
    let cardsView = UIView()
    var cardViewModels = [CardViewModel]()
    var user: User?
    private var lastFetchedUser: User?
    private var topCardView: CardView?
    private var previousCardView: CardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topStackView.settingButton.addTarget(self, action: #selector(presentInfoViewController), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomStackView.dislikeButton.addTarget(self, action: #selector(handleDisLike), for: .touchUpInside)
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser == nil {
            let registrationController = RegisterViewController()
            registrationController.delegate = self
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
            self.fetchSwipes()
        }
    }
    
    var swipes = [String : Int]()
    
    private func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("uid").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipes for currently user: ", err)
                return
            }
            let data = snapshot?.data() as? [String: Int] ?? [:]
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc private func handleRefresh() {
        if topCardView == nil {
            fetchCurrentUser()
        }
    }
    
    private func fetchUsersFromFirestore() {
        let minAge = user?.minSeekingAge ?? UserInfomationViewController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? UserInfomationViewController.defaultMaxSeekingAge
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Finding Matches"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { (snapshot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch users: ", err)
                return
            }
            snapshot?.documents.forEach({ (docsSnapshot) in
                let userDict = docsSnapshot.data()
                let user = User(dictionary: userDict)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setUpViewCardsFromUsers(user)
                    self.previousCardView?.nextCardView = cardView
                    self.previousCardView = cardView
                    if self.topCardView == nil {
                        self.topCardView = self.previousCardView
                    }
                }
            })
        }
    }
    
    @objc func handleDisLike() {
        saveSwipeInfomationToFireStore(didLike: 0)
        performSwipeAnimation(translation: -700, Angle: -15)
    }
    
    @objc func handleLike()  {
        saveSwipeInfomationToFireStore(didLike: 1)
        performSwipeAnimation(translation: 700, Angle: 15)
    }
    
    private func saveSwipeInfomationToFireStore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let cardUID = topCardView?.cardViewModel.uid else {
            return
        }
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch swipe document: ", err)
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save upload data: ", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfThereIsAmatch(with: cardUID)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data: ", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfThereIsAmatch(with: cardUID)
                    }
                }
            }
        }
    }
    
    private func checkIfThereIsAmatch(with cardUID: String) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                print("Failed to fetch document for card user: ", err)
                return
            }
            guard let data = snapshot?.data() else { return }
            guard let currentUserUID = Auth.auth().currentUser?.uid else {return}
            let hasMatched = data[currentUserUID] as? Int == 1
            if hasMatched {
                self.presentMatchView(cardUID: cardUID)
            }
        }
    }
    
    private func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = self.user
        view.addSubview(matchView)
        matchView.fillSuperview()
    }
    
    private func performSwipeAnimation(translation: CGFloat, Angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.5
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Angle * CGFloat.pi / 180
        rotationAnimation.duration = 0.5
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    func didRemoveCard(cardView: CardView) {
          self.topCardView?.removeFromSuperview()
          self.topCardView = self.topCardView?.nextCardView
    }
    
    private func setUpViewCardsFromUsers(_ user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsView.addSubview(cardView)
        cardsView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
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
        if topCardView == nil {
            fetchCurrentUser()
        }
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel!) {
        let userDetailsController = UserDetailViewController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
    
    func didFinishLoggingIn() {
        if topCardView == nil {
            fetchCurrentUser()
        }
    }
    
}
