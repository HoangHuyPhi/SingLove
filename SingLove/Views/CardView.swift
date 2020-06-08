//
//  CardView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/13/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel!)
    
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    private let swipingPhotosController = SwipingPhotosController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var imageView: UIView! {
        return swipingPhotosController.view
    }
    
    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
//            (0..<cardViewModel.imageUrls.count).forEach { (_) in
//                let barView = UIView()
//                barView.backgroundColor = barDeselectedColor
//                progressStackView.addArrangedSubview(barView)
//            }
//            progressStackView.arrangedSubviews.first?.backgroundColor = .white
//            setUpImageIndexObserver()
        }
    }
    
    private let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
//    private let imageView = UIImageView()
    
    
    private let infoLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    private let threshold: CGFloat = 80
    private let progressStackView = UIStackView()
    private var imageIndex = 0
    private let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayoutForView()
        disableScrollingForImageView()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
//    private func setUpImageIndexObserver() {
//        cardViewModel.imageIndexObserver = {[weak self] (index, imageUrl) in
//            if let url = URL(string: imageUrl ?? "") {
//                self?.imageView.sd_setImage(with: url)
//            }
//            self?.progressStackView.arrangedSubviews.forEach { (view) in
//                view.backgroundColor = self?.barDeselectedColor
//            }
//            self?.progressStackView.arrangedSubviews[index].backgroundColor = .white
//        }
//    }
    
    @objc private func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
    }
    
    @objc private func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.goToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    private func setUpLayoutForView() {
        layer.cornerRadius = 10
        clipsToBounds = true
        setUpImageView()
        setUpGradientLayer()
        setUpInfoLabel()
    }
    
    private func disableScrollingForImageView() {
        imageView.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    private func setUpImageView() {
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setUpInfoLabel() {
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
    }
    
//    private func setUpImagesCollection() {
//        addSubview(progressStackView)
//        progressStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
//        progressStackView.spacing = 4
//        progressStackView.distribution = .fillEqually
//    }
    
    private func setUpGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5 , 1.1]
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        gradientLayer.frame = self.frame
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: superview?.subviews.forEach({ (subView) in
            subView.layer.removeAllAnimations()
        })
        case .changed: handleChangedState(gesture)
        case .ended: handleEndedAnimation(gesture)
        default: ()
        }
    }
    
    private func handleChangedState(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let radian: CGFloat = translation.x / 20
        let angle = radian * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    private func handleEndedAnimation(_ gesture: UIPanGestureRecognizer) {
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.center = CGPoint(x: 1000 * translationDirection, y: 0)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
