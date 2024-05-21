//
//  NewsType.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

enum NewsType: String, CaseIterable {
    case apple = "apple"
   // case tesla = "tesla"
    case business = "business"
    case techCrunch = "techcrunch"
    case wallStreetJournal = "wsj.com"
    
   private var baseURL: String {
        return "https://newsapi.org/v2/"
    }

    private var path: String {
        switch self {
        case .apple, .wallStreetJournal:
            return "everything"
        case .business, .techCrunch:
            return "top-headlines"
        }
    }
    
    var name: String {
        switch self {
        case .apple:
            return "Apple"
//        case .tesla:
//            return "Tesla"
        case .business:
            return "Business"
        case .techCrunch:
            return "TechCrunch"
        case .wallStreetJournal:
            return "WTJ"
        }
    }
    
    private func queryItems(page: Int) -> [URLQueryItem] {
        var items = [URLQueryItem]()
        
        switch self {
        case .apple:
            items.append(contentsOf: [URLQueryItem(name: "q", value: rawValue),
                                      URLQueryItem(name: "from", value: "2024-05-14"),
                                      URLQueryItem(name: "to", value: "2024-05-14"),
                                      URLQueryItem(name: "sortBy", value: "popularity")])
//        case .tesla:
//            items.append(contentsOf: [URLQueryItem(name: "q", value: rawValue),
//                                      URLQueryItem(name: "from", value: "2024-04-15"),
//                                      URLQueryItem(name: "sortBy", value: "publishedAt")])
        case .business:
            items.append(contentsOf: [URLQueryItem(name: "country", value: "us"),
                                      URLQueryItem(name: "category", value: rawValue)])
            
        case .techCrunch:
            items.append(URLQueryItem(name: "sources", value: rawValue))
        case .wallStreetJournal:
            items.append(URLQueryItem(name: "domains", value: rawValue))
        }
        
        items.append(contentsOf: [URLQueryItem(name: "pageSize", value: "\(page)"),
                                  URLQueryItem(name: "apiKey", value: APIKey.value)])
        return items
    }
    
    func url(page: Int = 100) -> URL? {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems(page: page)
        return components?.url
    }
}

