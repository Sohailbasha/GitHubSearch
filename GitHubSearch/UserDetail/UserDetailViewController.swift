//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import UIKit
import SDWebImage
import Combine

class UserDetailViewController: UIViewController {

    var tableView: UITableView!
    
    var user: User!
    private var anyCancellable: AnyCancellable?

    private var repositories: [Repository] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var filteredArray: [Repository] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        tableView = UITableView()
        self.view.setSubviewForAutoLayout(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "repoCell")
        
        let customView = Bundle.main.loadNibNamed("\(CustomHeaderView.self)", owner: nil, options: nil)!.first as! CustomHeaderView
    
        customView.userBioLabel.text = user.bio ?? ""
        
        let url = URL(string: user.avatarURL!)
        customView.avatarImage.sd_setImage(with: url, completed: nil)
        
        customView.followerCountLabel.text = "Followers: \(user.followerCount ?? 0)"
        customView.followingCountLabel.text = "Following: \(user.followingCount ?? 0)"
        
        customView.emailLabel.text = user.email
        customView.locationLabel.text = user.location
        customView.joinDateLabel.text = user.createdAt

    
        self.tableView.setTableHeaderView(headerView: customView)
        self.tableView.updateHeaderViewFrame()
        
        let service = APIService()
        if let stringURL = user.reposURL, let reposURL = URL(string: stringURL) {
            self.anyCancellable = service.getRepositories(repositoryURL: reposURL).sink(receiveCompletion: { (_) in
                
            }, receiveValue: { (repos) in
                self.repositories = repos
                self.filteredArray = repos
            })
        }
        
        customView.headerSearchBar.delegate = self
        setUp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func setUp() {
        self.title = user.login ?? ""
    }
    
    func filterTableView(searchText: String) {
        
    }
}

// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        let repo = filteredArray[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // open safari webview
    }
}

extension UserDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredArray = repositories
        } else {
            let filtered = repositories.filter {$0.name!.contains(searchText)}
            self.filteredArray = filtered
        }
    }
}
