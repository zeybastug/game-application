//
//  VideoGamesTests.swift
//  VideoGamesTests
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import XCTest
@testable import VideoGames

final class VideoGamesTests: XCTestCase {
    
    var viewModel: GameViewModel!
    var fetchExpectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        viewModel = GameViewModel()
    }
    
    func getGames(){
        fetchExpectation.fulfill()
    }
    
    func testGetGames() throws {
        //When
        let expec = expectation(description: "Get Games")
        Client.getGames(page: 1) {res,_ in
            GamesViewController.games = res!.results
            expec.fulfill()
        }
        wait(for: [expec], timeout: 30)
        
        //Then
        XCTAssertEqual(GamesViewController.games.count, 20)
    }
    
    func  testGetGenres() throws {
        let expec = expectation(description: "Get Genres")
        Client.getGenreOptions() { [weak self] res, error in
            guard let self = self else { return }
            self.viewModel.handleGenreOptionsResponse(res, self.viewModel)
            expec.fulfill()
        }
        wait(for: [expec], timeout: 30)
        
        //Then
        XCTAssertEqual(viewModel.genreList.count, 20)
        XCTAssertEqual(viewModel.genreList[0].name, "All Games")
    }
}




