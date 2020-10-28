//
//  ImageVIew.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    private var currentImageUrl: String?
    
    func set(imageUrl: String?) {
        currentImageUrl = imageUrl
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = nil
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                guard let data = data, let response = response else { return }
                self.handleCachedImage(data: data, response: response)
            }
        }.resume()
        
    }
    
    
    private func handleCachedImage(data: Data, response: URLResponse) {
        guard let responseUrl = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseUrl))
        
        if responseUrl.absoluteString == currentImageUrl {
            self.image = UIImage(data: data)
        }
        
        
    }
    
    
    
    
}
