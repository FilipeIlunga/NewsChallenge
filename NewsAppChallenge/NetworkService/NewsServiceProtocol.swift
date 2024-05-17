//
//  NewsServiceProtocol.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews<T: Decodable>(type: NewsType, page: Int) async throws -> T
    func fetchImage(url: String, completionBlock: @escaping (Result<Data,Error>) -> ())

}
