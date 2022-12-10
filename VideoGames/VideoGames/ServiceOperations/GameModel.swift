//
//  GameModel.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//

import Foundation

struct Result:Codable {
    
    var results:[GameModel]
}

struct GameModel:Codable {
    
    var id:Int?
    var name:String?
}
