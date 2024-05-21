//
//  NewsServiceProtocol.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

protocol NewsServiceProtocol {
    typealias NetworkResult = Result<(Data,HTTPURLResponse), NewsServiceError>
    func request(url: URL, completion: @escaping (NetworkResult) -> Void)
}
