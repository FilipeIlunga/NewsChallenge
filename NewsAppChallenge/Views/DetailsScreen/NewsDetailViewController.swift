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
        super.init(nibName: <#T##String?#>, bundle: <#T##Bundle?#>)
        self.news = news
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
