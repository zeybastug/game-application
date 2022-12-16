//
//  NoteTableViewCell.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var noteLabel: UILabel!
    
    func configureCell(model: Note) {
        noteLabel.text = model.noteText
        gameNameLabel.text = model.name
        
    }

}
