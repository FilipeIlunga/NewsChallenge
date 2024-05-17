//
//  NewsService.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

class NewsService: NewsServiceProtocol {
    
    private let defaultSession = URLSession(configuration: .default)
    
    func fetchNews<T: Decodable>(type: NewsType, page: Int, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = type.url(page: page) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        let dataTask = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(T.self, from: data)
                    completion(.success(responseObject))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        dataTask.resume()
    }
    
    func fetchNews<T: Decodable>(type: NewsType, page: Int) async throws -> T {
        guard let url = type.url(page: page) else {
            throw NetworkError.badURL
        }
        
        let (data, _) = try await defaultSession.data(from: url)
        let result: T = try decode(data: data)
        return result
        
    }

    func fetchImage(url: String, completionBlock: @escaping (Result<Data, any Error>) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionBlock(.failure(error))
            }
            
            if let data = data  {
                completionBlock(.success(data))
            } else {
                completionBlock(.failure(NetworkError.badData))
            }
        }.resume()
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        let decoder: JSONDecoder = JSONDecoder()
        
        do {
            let resultData: T = try decoder.decode(T.self, from: data)
            return resultData
        } catch {
            throw error
        }
    }
}
