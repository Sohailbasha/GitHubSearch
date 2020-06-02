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

protocol UserDetailInterfacing {
    static func create(user: User, service: APIService) -> UserDetailViewController
}

class UserDetailViewController: UIViewController {

    private let reuseIdentifier = "repoCell"

    var tableView: UITableView!
    var profileHeader: ProfileHeaderView!

    // user object that acts as a dataprovider for this screen
    var user: User!
    // the class used to make API calls
    var apiService: APIService!

    private var anyCancellable: AnyCancellable?

    private var repositories: [Repository] = []
    private var filteredRepositories: [Repository] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = user.login ?? ""

        setupTableView()
        setupTableViewHeader()
        fetchRepositories()
    }

    func setupTableView() {
        tableView = UITableView()
        self.view.setSubviewForAutoLayout(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

    func setupTableViewHeader() {
        let bundle = Bundle(for: ProfileHeaderView.self)
        let nib = bundle.loadNibNamed(String(describing: ProfileHeaderView.self), owner: nil)
        if let headerView = nib?.first as? ProfileHeaderView {
            self.profileHeader = headerView
        }

        profileHeader.setupView(user: user)
        profileHeader.headerSearchBar.delegate = self

        tableView.setTableHeaderView(headerView: profileHeader)
        tableView.updateHeaderViewFrame()
    }

    func fetchRepositories() {
        if let stringURL = user.reposURL, let reposURL = URL(string: stringURL) {
            self.anyCancellable = apiService.getRepositories(repositoryURL: reposURL).sink(receiveCompletion: { (_) in
                // do something on complete
            }, receiveValue: { (repos) in
                self.repositories = repos
                self.filteredRepositories = repos
            })
        }
    }
}

// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let repo = filteredRepositories[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = filteredRepositories[indexPath.row]
        if let url = URL(string: repository.htmlURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension UserDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTableView(searchText: searchText)
    }

    func filterTableView(searchText: String) {
        if searchText == "" {
            filteredRepositories = repositories
        } else {
            let filtered = repositories.filter {$0.name.lowercased().contains(searchText.lowercased())}
            self.filteredRepositories = filtered
        }
    }
}

extension UserDetailViewController: UserDetailInterfacing {
    static func create(user: User, service: APIService) -> UserDetailViewController {
        let viewController = UserDetailViewController()
        viewController.user = user
        viewController.apiService = service
        return viewController
    }
}
