//
//  FavouritesViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class FavouritesViewController: UIViewController, UITabBarDelegate, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabAppearance = UITabBarAppearance()
        changeColor(itemAppearance: tabAppearance.stackedLayoutAppearance)
        changeColor(itemAppearance: tabAppearance.inlineLayoutAppearance)
        changeColor(itemAppearance: tabAppearance.compactInlineLayoutAppearance)
        
        tabBarController?.delegate = self
        tabBarController?.tabBar.standardAppearance = tabAppearance
        tabBarController?.tabBar.scrollEdgeAppearance = tabAppearance
        
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
        itemAppearance.selected.iconColor = UIColor(named: "selectColor")
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "selectColor") ?? UIColor.green]
    }


}




