//
//  AlertError.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 11.12.2022.
//

import Foundation

enum AlertError: Error {
    case emptyInput
    case wrongInput
    case success
}

extension AlertError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .emptyInput:
            return "Value cannot be blank. Please enter a value.".localizableString(GamesViewController.selectedLanguage)
        case .wrongInput:
            return "Please enter a valid value.".localizableString(GamesViewController.selectedLanguage)
        case .success:
            return "Success".localizableString(GamesViewController.selectedLanguage)
        }
    }
}
