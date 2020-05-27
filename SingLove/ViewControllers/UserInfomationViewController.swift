//
//  UserInfomationViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class HeaderLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 16, dy: 0))
    }
    
}


class UserInfomationViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc private func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        let fileName = UUID().uuid
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {
            return
        }
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) {
            (nil, err) in
            hud.dismiss()
            if let err = err {
                print("Failed to upload images to storage: ", err)
                return
            }
            print("Finished uploading image")
            ref.downloadURL { (url, err) in
                if let err = err {
                    print("Failed to retrieve download URL: ", err)
                    return
                }
                print("Finished getting download url: ", url?.absoluteString ?? "")
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        }
    }
    
    private func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photos", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
    }
    
    var user: User?
    
    private func fetchCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("user").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                print(err)
                return
            }
            guard let dictionary = snapshot?.data() else {
                return
            }
            self.user = User(dictionary: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    private func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options:.continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.image1Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options:.continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.image1Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl)  {
            SDWebImageManager.shared.loadImage(with: url, options:.continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.image1Button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        let verticalStackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        verticalStackView.distribution = .fillEqually
        verticalStackView.axis = .vertical
        verticalStackView.spacing = padding
        header.addSubview(verticalStackView)
        verticalStackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        switch section {
        case 1: headerLabel.text = "Name"
        case 2: headerLabel.text = "Profession"
        case 3: headerLabel.text = "Age"
        case 4: headerLabel.text = "Bio"
        default: headerLabel.text = "Seeking Age Range"
        }
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    @objc private func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Min: \(Int(slider.value))"
        
    }
    
    @objc private func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        let ageRangeCell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        ageRangeCell.minLabel.text = "Max: \(Int(slider.value))"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            return ageRangeCell
        }
        
        let cell = InfoCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default: cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc private func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc private func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc private func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    
    fileprivate func setUpNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCloseView))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        ]
    }
    
    @objc private func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let docData: [String : Any] = [
            "uid" : uid,
            "fullName": user?.name ?? "",
            "imageUrl": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "age": 60,
            "profession": user?.profession ?? ""
        ]
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving info"
        hud.show(in: view)
        Firestore.firestore().collection("user").document(uid).setData(docData, completion: {
            (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user infomation, ", err)
                return
            }
            print("Finished saving user info")
        })
    }
    @objc private func handleLogout() {
        print("Logout")
    }
    
    @objc private func handleCloseView() {
        print("Close")
    }
    
}
