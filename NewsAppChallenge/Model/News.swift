//
//  News.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

struct News: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?    
    var imageCoverData: Data?
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }
}

struct NewsDataResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

struct Source: Codable {
    let id: String?
    let name: String
}
