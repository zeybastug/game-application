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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouritesTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
     FavouritesViewController.favouriteList = CoreDataManager.shared.getFavourites()
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
        
        cell.configureCell(model: model)
        return cell
    }
    
    
    
}




