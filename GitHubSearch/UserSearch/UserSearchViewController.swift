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

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    private var anyCancellable: AnyCancellable?

    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
            for user in self.users {
                print(user.login)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}

// MARK: - Search bar delegate
extension UserSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            let service = APIService()
            self.anyCancellable = service.getAllData(query: searchText).sink(receiveCompletion: { _ in
            }, receiveValue: { (users) in
                self.users = users
            })
        })
    }
}
