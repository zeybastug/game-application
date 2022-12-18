//
//  DetailModel.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 11.12.2022.
//

import Foundation

struct DetailModel:Codable {
    
    var description:String?
    var released:String?
    var rating:Double?
    var platforms:[Platform]?
    var developers:[Developer]?
    var genres:[Genre]?
}

struct Platform:Codable {
    
    var platform:PlatformInfo?
}

struct PlatformInfo:Codable {
    
    var id:Int?
    var name:String?
}

struct Developer:Codable {
    
    var id:Int?
    var name:String?
}

struct Genre:Codable {
    
    var id:Int?
    var name:String?
}

