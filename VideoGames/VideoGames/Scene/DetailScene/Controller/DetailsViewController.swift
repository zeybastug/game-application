//
//  DetailsViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 11.12.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var gameName: UILabel!
   
    @IBOutlet weak var gameDescription: UITextView!
    
    @IBOutlet weak var gameRating: UILabel!
    @IBOutlet weak var gameRelease: UILabel!
    @IBOutlet weak var gameDeveloper: UILabel!
    @IBOutlet weak var gameGenre: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    var gameModel:GameModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Client.getDetails(id: (gameModel?.id)!) { [weak self] res, error in
            guard let self = self else { return }
            self.gameName.text = self.gameModel?.name
            Client.setImage(onImageView: self.gameImage, withImageUrl: self.gameModel?.backgroundImage!, placeHolderImage: UIImage())
            self.gameDescription.text = res?.description
            self.gameRating.text      = String(res?.rating ?? 0)
            self.gameRelease.text     = res?.released
            self.gameDeveloper.text   = res?.developers![0].name!
            self.gameGenre.text       = res?.genres![0].name!
            self.view.reloadInputViews()
        }
        
    }
    
    
    @IBAction func likeButton(_ sender: Any) {
        
        if((FavouritesViewController.favouriteList?.contains(where: { FavouriteGame in
            FavouriteGame.name == gameModel?.name
        }))!)
        {
            return
        }
        CoreDataManager.shared.addToFavourites(name: (gameModel?.name)!)
        
    }
    

   

}
