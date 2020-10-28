//
//  FeedParser.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

protocol FeedParserProtocol {
    func getFeeds(response: @escaping ([String: [RSSItem]]) -> Void)
}

class FeedParser: NSObject, XMLParserDelegate, FeedParserProtocol {
    
    private var currentElement = String()
    private var currentEnclosure = [String]()
    private var currentTitle = String()
    private var currentDescription = String()
    private var currentPubDate = String()
    private var currentFullText = String()
    private var currentCategory = String()

    private var rssDict = [String: [RSSItem]]()
    
    let networking: Networking
    
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func getFeeds(response: @escaping ([String: [RSSItem]]) -> Void) {
        
        networking.request { (data, error) in
            if let error = error {
                print("Error requesting data: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            response(self.rssDict)
            self.rssDict.removeAll()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = String()
            currentDescription = String()
            currentPubDate = String()
            currentFullText = String()
            currentEnclosure = []
            currentCategory = String()
        }
        
        if currentElement == "enclosure" {
            if let urlString = attributeDict["url"] {
                currentEnclosure.append(urlString)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, description: currentDescription, enclosure: currentEnclosure, fullText: currentFullText, category: currentCategory)
            if rssDict[currentCategory] == nil {
                rssDict[currentCategory] = [rssItem]
            } else {
                rssDict[currentCategory]!.append(rssItem)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        case "yandex:full-text": currentFullText += string
        case "category": currentCategory += string
        default: break
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
