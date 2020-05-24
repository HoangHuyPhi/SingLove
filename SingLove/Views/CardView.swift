//
//  CardView.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/13/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            imageView.image = UIImage(named: imageName)
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                progressStackView.addArrangedSubview(barView)
            }
            progressStackView.arrangedSubviews.first?.backgroundColor = .white
            setUpImageIndexObserver()
        }
    }
    
    private func setUpImageIndexObserver() {
        cardViewModel.imageIndexObserver = {[weak self] (index, image) in
            self?.imageView.image = image
            self?.progressStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self?.barDeselectedColor
            }
            self?.progressStackView.arrangedSubviews[index].backgroundColor = .white
            
        }
    }
    
    private let imageView = UIImageView()
    private let infoLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    private let threshold: CGFloat = 80
    private let progressStackView = UIStackView()
    private var imageIndex = 0
    private let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayoutForView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
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
        setUpImagesCollection()
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
    
    private func setUpImagesCollection() {
        addSubview(progressStackView)
        progressStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        progressStackView.spacing = 4
        progressStackView.distribution = .fillEqually
    }
    
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
