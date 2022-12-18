//
//  DetailTests.swift
//  VideoGamesTests
//
//  Created by Zeynep Baştuğ on 18.12.2022.
//


import XCTest
@testable import VideoGames

import Foundation

final class DetailTests: XCTestCase {
    
    var viewModel: DetailsViewController!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        viewModel = DetailsViewController()
    }
    
    func likeGameTest()
    {
        viewModel.gameModel = GameModel()
        viewModel.gameModel?.name = "Counter Strike"
        viewModel.likeAction()
        XCTAssertTrue((FavouritesViewController.favouriteList?.contains(where: { FavouriteGame in
            FavouriteGame.name == viewModel.gameModel?.name
        }))!)
    }
}
