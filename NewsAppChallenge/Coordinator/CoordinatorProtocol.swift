//
//  CoordinatorProtocol.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 17/05/24.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
