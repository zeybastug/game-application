//
//  GameTableViewCell.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

final class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    
    func configureCell(model: GameModel) {
        gameNameLabel.text = model.name
        Client.setImage(onImageView: gameImageView, withImageUrl: model.backgroundImage ?? "", placeHolderImage: UIImage())
    }
    
}
