//
//  UserInfomationViewController.swift
//  SingLove
//
//  Created by Phi Hoang Huy on 5/25/20.
//  Copyright © 2020 Phi Hoang Huy. All rights reserved.
//

import UIKit

class UserInfomationViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.separatorStyle = .none
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
        print("Save")
    }
    
    @objc private func handleLogout() {
        print("Logout")
    }
    
    @objc private func handleCloseView() {
        print("Close")
    }
    
}
