//
//  SwipingPhotosControllver.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 6/7/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    
    var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> UIViewController in
                return PhotoController(imageUrl: imageUrl)
            })
            setUpBarView()
            setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentPhotoController = viewControllers?.first
        if let index = controllers.firstIndex(where: { (vc) -> Bool in
            return vc == currentPhotoController
        }) {
            barsStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = deselectedBarColor
            }
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    var controllers = [UIViewController]()
    
    private let barsStackView = UIStackView(arrangedSubviews: [])
    private let deselectedBarColor = UIColor(white: 0, alpha: 0.1)
    
    private func setUpBarView() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = deselectedBarColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
        barsStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        view.backgroundColor = .white
        dataSource = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
           let currentController = viewControllers!.first!
           if let index = controllers.firstIndex(of: currentController) {
               
               barsStackView.arrangedSubviews.forEach({$0.backgroundColor = deselectedBarColor})
               
               if gesture.location(in: self.view).x > view.frame.width / 2 {
                   let nextIndex = min(index + 1, controllers.count - 1)
                   let nextController = controllers[nextIndex]
                   setViewControllers([nextController], direction: .forward, animated: false)
                   barsStackView.arrangedSubviews[nextIndex].backgroundColor = .white
                   
               } else {
                   let prevIndex = max(0, index - 1)
                   let prevController = controllers[prevIndex]
                   setViewControllers([prevController], direction: .forward, animated: false)
                   barsStackView.arrangedSubviews[prevIndex].backgroundColor = .white
               }
           }
       }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (photo) -> Bool in
            photo == viewController
            } ?? -1
        if index == 0 {return nil}
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.controllers.firstIndex { (photo) -> Bool in
            photo == viewController
            } ?? -1
        if index == controllers.count - 1 {return nil}
        return controllers[index + 1]
    }
}



class PhotoController: UIViewController {
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
    
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.addSubview(imageView)
        imageView.fillSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true 
    }
}
