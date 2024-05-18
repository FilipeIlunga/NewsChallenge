//
//  NewsDetailViewController.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 17/05/24.
//

import UIKit

class NewsDetailViewController: UIViewController {
    let news: News
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = news.title
        view.backgroundColor = .red
    }
}
