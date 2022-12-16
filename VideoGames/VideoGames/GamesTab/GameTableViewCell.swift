//
//  GameTableViewCell.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
    func configureCell(model: GameModel) {
        gameNameLabel.text = model.name
//        Client.downloadImages(image: model.background_image!, imageView: gameImageView)
        Client.setImage(onImageView: gameImageView, withImageUrl: model.background_image!, placeHolderImage: UIImage())
    }

}
