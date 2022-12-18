//
//  BaseViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//

import UIKit
import MaterialActivityIndicator
import SwiftAlertView

class BaseViewController: UIViewController, UITabBarDelegate, UITabBarControllerDelegate {
    
    let indicator = MaterialActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicatorView()
        
        let tabAppearance = UITabBarAppearance()
        changeColor(itemAppearance: tabAppearance.stackedLayoutAppearance)
        changeColor(itemAppearance: tabAppearance.inlineLayoutAppearance)
        changeColor(itemAppearance: tabAppearance.compactInlineLayoutAppearance)
        
        tabBarController?.delegate = self
        tabBarController?.tabBar.standardAppearance = tabAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
        
        tabAppearance.backgroundColor = UIColor(named: "naviColor")
        
        
        let navAppearance = UINavigationBarAppearance()
        
        navAppearance.backgroundColor = UIColor(named: "naviColor")
        navAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navAppearance
        navigationController?.navigationBar.compactAppearance = navAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navAppearance
        
    }
    
    func changeColor(itemAppearance:UITabBarItemAppearance)
    {
        itemAppearance.normal.iconColor = UIColor.black
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        itemAppearance.selected.iconColor = UIColor(named: "naviColor")
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "naviColor") ?? UIColor.green]
    }
    
    private func setupActivityIndicatorView() {
        view.addSubview(indicator)
        setupActivityIndicatorViewConstraints()
    }
    
    private func setupActivityIndicatorViewConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func showErrorAlert(message: String, completion: @escaping () -> Void) {
        SwiftAlertView.show(title: "Error",
                            message: message,
                            buttonTitles: ["OK"]).onButtonClicked { _, _ in
            completion()
        }
    }
}




