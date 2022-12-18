//
//  FavouritesViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class FavouritesViewController: BaseViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    
    static var favouriteList:[FavouriteGame]?
    
    static var deletedList : [FavouriteGame] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favouritesTableView.backgroundColor = UIColor(named: "naviColor")
        favouritesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.items![0].title =         navigationController?.navigationBar.items![0].title?.localizableString(GamesViewController.selectedLanguage)
        
        FavouritesViewController.favouriteList = CoreDataManager.shared.getFavourites()
        favouritesTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        FavouritesViewController.deletedList.forEach { String in
            CoreDataManager.shared.deleteFav(fav: String)
        }
        FavouritesViewController.deletedList = []
        favouritesTableView.reloadData()
    }
    
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FavouritesViewController.favouriteList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? FavouriteTableViewCell, let model = FavouritesViewController.favouriteList?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.likeButton.tag = indexPath.row
        cell.likeButton.setImage(UIImage(systemName: "heart-fill"), for: .normal)
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .selected)
        cell.backgroundColor = UIColor(named: "cellColor")
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.configureCell(model: model,tableView: self.favouritesTableView)
        return cell
    }
}




