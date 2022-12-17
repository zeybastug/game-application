//
//  GameModel.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//

import Foundation

struct Result:Decodable {
    
    var results:[GameModel]
}

struct GameModel:Decodable {
    
    var id:Int?
    var name:String?
    //    var genres:[GameGenre]
    var backgroundImage:String?
    var released:String?
    var rating:Double?
    
    enum CodingKeys: String,CodingKey {
        
        case backgroundImage = "background_image"
        case name
        case id
        case released
        case rating
        // case results
    }
}

//
//struct GameGenre:Codable {
//
//    var id:Int?
//    var name:String?
//}
