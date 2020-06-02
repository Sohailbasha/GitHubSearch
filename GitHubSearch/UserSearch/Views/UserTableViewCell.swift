//
//  UserTableViewCell.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repoCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func setup(userName: String, repoCount: String, imageURL: URL?) {
        userNameLabel.text = userName
        repoCountLabel.text = repoCount
        avatarImageView.sd_setImage(with: imageURL, completed: nil)
    }
}
