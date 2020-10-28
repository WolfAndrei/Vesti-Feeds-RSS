//
//  NetworkFetcher.swift
//  Vesti Feeds RSS
//
//  Created by Andrei Volkau on 27.10.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation

protocol Networking {
    func request(completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        return task
    }
    
    private func url() -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.path
        print(components.url!)
        return components.url!
    }
    
    func request(completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url()
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
}



