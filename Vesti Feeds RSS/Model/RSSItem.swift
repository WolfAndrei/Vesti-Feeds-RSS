//
//  RSSModel.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

struct RSSItem {
    var title: String
    var pubDate: String
    var description: String
    var enclosure: [String]
    var fullText: String
    var category: String
}
