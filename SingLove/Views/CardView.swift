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
            imageView.image = UIImage(named: cardViewModel.imageName)
            infoLabel.attributedText = cardViewModel.attributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
        }
        
    }
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
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
        let shouldDismissCard = true
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.center = CGPoint(x: 1000 * translationDirection, y: 0)
            } else {
                self.transform = .identity
            }
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
