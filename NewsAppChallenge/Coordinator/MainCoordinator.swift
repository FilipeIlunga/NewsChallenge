//
//  MainCoordinator.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 17/05/24.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let service = NewsService()
        let newsViewmodel = NewsHomeViewModel(newsService: service)
        let vc = NewsHomeViewController(viewModel: newsViewmodel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showNewsDetail(news: News) {
        let detailVC = NewsDetailViewController(news: news)
        navigationController.pushViewController(detailVC, animated: false)
    }
}

