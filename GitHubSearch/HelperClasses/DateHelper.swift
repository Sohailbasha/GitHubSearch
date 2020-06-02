//
//  DateHelper.swift
//  GitHubSearch
//
//  Created by Ilias Basha on 6/1/20.
//  Copyright © 2020 sohail. All rights reserved.
//

import Foundation

class DateHelper {

    static func getFormatedDate(dateString: String?)-> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let dateString = dateString, let date  = formatter.date(from: dateString)  {
            formatter.dateFormat = "MMM dd, yy"
            return formatter.string(from: date)
        }
        return nil
    }
}
