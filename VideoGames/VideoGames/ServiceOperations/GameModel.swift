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
    var genres:[GameGenre]
    var background_image:String?
    }

//private enum CodingKeys: String,CodingKey {
//
//
//    case backgroundImage = "background_image"
//    case name
//    case id
//    case results
//}

struct GameGenre:Codable {

    var id:Int?
    var name:String?
}
