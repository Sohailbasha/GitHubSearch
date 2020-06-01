//
//  UIView+Extension.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 5/31/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    static var nib: UINib {
        let bundle = Bundle(for: classForCoder())
        return UINib(nibName: String(describing: classForCoder()), bundle: bundle)
    }

    func setSubviewForAutoLayout(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
    }

    func setSubviewsForAutoLayout(_ subviews: [UIView]) {
        subviews.forEach(self.setSubviewForAutoLayout)
    }
}



extension UITableView {
    
    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set first.
        self.tableHeaderView = headerView
        
        // Then setup AutoLayout.
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }
        
        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()
        
        // ***Trigger table view to know that header should be updated.
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}
