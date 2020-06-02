//
//  CustomHeaderView.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 6/1/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileHeaderView: UIView {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var joinDateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var headerSearchBar: UISearchBar!

    func setupView(user: User) {
        emailLabel.text = user.email
        locationLabel.text = user.location
        followerCountLabel.text = "Followers: \(user.followerCount ?? 0)"
        followingCountLabel.text = "Following: \(user.followingCount ?? 0)"
        userBioLabel.text = user.bio

        let imageURL = URL(string: user.avatarURL ?? "")
        avatarImage.sd_setImage(with: imageURL, completed: nil)

        if let dateString = DateHelper.getFormatedDate(dateString: user.createdAt) {
            joinDateLabel.text = "Member since \(dateString)"
        }
    }
}
