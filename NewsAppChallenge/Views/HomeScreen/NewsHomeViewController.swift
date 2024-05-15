//
//  NewsHomeViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 14/05/24.
//

import UIKit

class NewsHomeViewController: UIViewController {

    let newsService: NewsServiceProtocol

    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

}

