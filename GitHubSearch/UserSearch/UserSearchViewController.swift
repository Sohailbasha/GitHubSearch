//
//  UserSearchViewController.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import UIKit
import Combine

class UserSearchViewController: UITableViewController {

    fileprivate let reuseIdentifier = "usersCell"
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var anyCancellable: AnyCancellable?

    var timer: Timer?
    var service: APIService!

    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        service = APIService()
        self.title = "GitHub Search"
        tableView.register(UserTableViewCell.nib, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        setupSearchBar()
    }

    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.automaticallyShowsCancelButton = false
    }
}

// MARK: - Table view data source
extension UserSearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none

        let user = users[indexPath.row]
        let userName = user.login ?? ""
        let repoCount = user.repoCount ?? 0
        let imageURL = URL(string: user.avatarURL ?? "")

        cell.setup(userName: userName, repoCount: "\(repoCount)", imageURL: imageURL)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let userDetailVC = UserDetailViewController.create(user: user, service: service)
        let navigationController = UINavigationController(rootViewController: userDetailVC)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Search bar delegate
extension UserSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchUsers(searchText)
    }

    // Make API call using search bars `searchText` as a query
    func searchUsers(_ searchText: String) {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = tableView.center
        indicator.hidesWhenStopped = true

        if searchText == "" {
            self.users = []
        } else {
            // debounce api search by half a second. This is so we do not make extranous network calls.
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.view.addSubview(indicator)
                indicator.startAnimating()
                let service = APIService()
                self.anyCancellable = service.getAllUserData(query: searchText).sink(receiveCompletion: { _ in
                }, receiveValue: { (users) in
                    indicator.stopAnimating()
                    self.users = users
                })
            })
        }
    }
}
