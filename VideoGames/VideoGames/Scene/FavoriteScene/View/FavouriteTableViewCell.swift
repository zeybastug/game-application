//
//  FavouriteTableViewCell.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var favouriteGame: UILabel!
    
    
    func configureCell(model:FavouriteGame){
        
        favouriteGame.text = model.name
        
    }
}
