//
//  GenreModel.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 13.12.2022.
//

import Foundation

struct ResultModel:Codable {
    
    var results:[GenreModel]
}

struct GenreModel:Codable {
    
    var id:Int?
    var name:String?
    var slug:String?
}
