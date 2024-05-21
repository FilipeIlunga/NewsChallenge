//
//  NewsServiceError.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 21/05/24.
//

import Foundation


enum NewsServiceError: LocalizedError {
    case unexpectedValues
    case decodingError
    case networkError(Error)
    case badURL
    
    var localizedDescription: String {
        switch self {
        case .unexpectedValues:
            return "An unexpected error occurred. Please try again."
        case .decodingError:
            return "There was a problem loading the news. Please try again."
        case .networkError(let error):
            return "There was a network problem: \(error.localizedDescription)"
        case .badURL:
            return "Error on load URL. Please try again."
        }
    }
}
