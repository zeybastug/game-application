//
//  FavouriteTableViewCell.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var favouriteGame: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    var tableView:UITableView?
    
    func configureCell(model:FavouriteGame,tableView:UITableView){
        
        favouriteGame.text = model.name
        self.tableView = tableView
        
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        let fav:FavouriteGame = FavouritesViewController.favouriteList![sender.tag]
        if(FavouritesViewController.deletedList.contains(where: { String in
            String.name == fav.name
        })) {
            FavouritesViewController.deletedList.removeAll { String in
                String.name == fav.name
            }
        } else {
            FavouritesViewController.deletedList.append(fav)
        }
        sender.isSelected = !sender.isSelected
    }
    
    
}
