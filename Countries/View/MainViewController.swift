//
//  MainViewController.swift
//  Countries
//
//  Created by Sezgin Çiftci on 7.01.2022.
//

import UIKit

enum Cell_ID : String {
    case saveCell = "saveCell"
    case homeCell = "homeCell"
}

class MainViewController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        configureTabBar()
    }
    
    private func configureTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let savedVC = UINavigationController(rootViewController: SavedViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        savedVC.tabBarItem.image = UIImage(systemName: "heart.fill")
        savedVC.tabBarItem.image = UIImage(systemName: "heart.fill")
        homeVC.tabBarItem.title = "Home"
        savedVC.tabBarItem.title = "Saved"
        savedVC.tabBarItem.title = "Saved"
        tabBarVC.tabBar.backgroundColor = .systemGray
        tabBarVC.setViewControllers([homeVC, savedVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.tintColor = .white
        present(tabBarVC, animated: true, completion: nil)
        
    }
}

