//
//  Extension String.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

extension String {
    func convertDateInNewFormat(from oldFormat: String, oldIdentifier: String = "en_US", to newFormat: String, newIdentifier: String = "ru_RU") -> String {
        let dateFormatter = DateFormatter()
        //old format
        dateFormatter.locale = Locale(identifier: oldIdentifier)
        dateFormatter.dateFormat = oldFormat
        let date = dateFormatter.date(from: self)
        
        //newFormat
        dateFormatter.locale = Locale(identifier: newIdentifier)
        dateFormatter.dateFormat = newFormat
        let formattedDate = dateFormatter.string(from: date!)
        return formattedDate
    }
}
