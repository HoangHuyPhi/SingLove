//
//  UserDetailViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/30/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UIScrollViewDelegate {
    
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    private lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    private let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var swipeView: UIView! {
        return swipingPhotosController.view
    }
    private let SwipingHeight: CGFloat = 80
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let dismissButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        bt.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return bt
    }()
    
    private lazy var disLikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDisLike))
    private lazy var superLikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleSuperLike))
    private lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleLike))
    
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    @objc private func handleDisLike() {
        
    }
    
    @objc private func handleLike() {
          
    }
    
    @objc private func handleSuperLike() {
          
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpVisualBlurEffect()
        setUpBottomButtons()
    }
    
    private func setUpBottomButtons() {
        let stackView = UIStackView(arrangedSubviews: [disLikeButton, superLikeButton, likeButton])
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setUpVisualBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setUpLayout() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
        scrollView.fillSuperview()
        scrollView.addSubview(swipeView)
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: swipeView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: swipeView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -25, left: 0, bottom: 0, right: 50), size: .init(width: 50, height: 50))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         swipeView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + SwipingHeight)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        var stretchyHeaderConstant = view.frame.width + changeY * 2
        stretchyHeaderConstant = max(view.frame.width, stretchyHeaderConstant)
        swipeView.frame = CGRect(x: min(0, -changeY), y: min(0, -changeY), width: stretchyHeaderConstant, height: stretchyHeaderConstant)
    }
    
    @objc private func handleTapDismiss() {
        self.dismiss(animated: true)
    }

}
