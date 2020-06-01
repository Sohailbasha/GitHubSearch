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
