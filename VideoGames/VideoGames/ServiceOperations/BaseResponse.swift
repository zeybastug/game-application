//
//  BaseResponse.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//

import Foundation


struct BaseResponse: Codable {
    let status: Int
    let error: String
}

extension BaseResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
