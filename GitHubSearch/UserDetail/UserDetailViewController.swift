//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        self.title = user.login ?? ""
    }

}
