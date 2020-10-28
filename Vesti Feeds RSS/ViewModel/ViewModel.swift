//
//  ViewModel.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

protocol FeedCellViewModel {
    var title: String { get }
    var pubDate: String { get }
    var fullText: String { get }
    var enclosures: [String] { get }
}

struct FeedViewModel {
    
    struct Cell: FeedCellViewModel {
        var title: String
        var pubDate: String
        var fullText: String
        var enclosures: [String]
        var category: String
    }
    
    var feedItems: [String: [Cell]]
    
    //for filtering
    var sections: [String] {
        return Array(feedItems.keys).sorted()
    }
    var unfilteredItems: [Cell] {
        feedItems.map { $0.value }.reduce([], +).sorted { $0.pubDate > $1.pubDate }
    }
    
    //prepare viewModel
    func presentViewModel(from items: [RSSItem]) -> [FeedViewModel.Cell] {     
        return items.map { FeedViewModel.Cell(title: $0.title, pubDate: formattedDate(date: $0.pubDate), fullText: $0.fullText, enclosures: $0.enclosure, category: $0.category) }
    }
    
    //get formatted date
    private func formattedDate(date: String) -> String {
        return date.convertDateInNewFormat(from: "EEE, dd MMM yyyy HH:mm:ss zzz", to: "d MMM 'в' HH:mm")
    }
    
    //numberOfSections
    func numberOfSections() -> Int {
        return feedItems.keys.count
    }
    
    // numberOfRows
    func numberOfRowsUnfiltered() -> Int {
        return unfilteredItems.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return feedItems[sections[section]]!.count
    }
    
    //titleForSection
    func title(forSection section: Int) -> String {
        return sections[section].prefix(1).capitalized + sections[section].dropFirst()
    }
    
    //fill up the cell with data
    func viewModel(forIndexPath indexPath: IndexPath) -> Cell {
        return feedItems[sections[indexPath.section]]![indexPath.row]
    }
    
    func viewModelForUnfilteredFeeds(forIndexPath indexPath: IndexPath) -> Cell {
        return unfilteredItems[indexPath.row]
    }
    
}
