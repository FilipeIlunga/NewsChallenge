//
//  NewsService.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

class NetworkService: NewsServiceProtocol {
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(url: URL, completion: @escaping (NetworkResult) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
 
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
                
            } else {
                let error = NSError(domain: "unexpected values", code: -1)
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}
