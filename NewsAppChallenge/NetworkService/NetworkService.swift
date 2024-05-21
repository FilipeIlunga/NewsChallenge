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
    
    func request<T: Decodable>(url: URL, type: T.Type, completion: @escaping (NetworkResult) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
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
    
    func request<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        
        let (data, _) = try await session.data(from: url)
        let result: T = try decode(data: data)
        return result
        
    }

    func fetchImage(url: String, completionBlock: @escaping (Result<Data, any Error>) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        session.dataTask(with: url) { data, response, error in
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
