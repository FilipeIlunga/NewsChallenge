//
//  NewsServiceProtocol.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

protocol NewsServiceProtocol {
    func request<T: Decodable>(url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)  
    func request<T: Decodable>(url: URL, type: T.Type) async throws -> T
    func fetchImage(url: String, completionBlock: @escaping (Result<Data,Error>) -> ())
}
