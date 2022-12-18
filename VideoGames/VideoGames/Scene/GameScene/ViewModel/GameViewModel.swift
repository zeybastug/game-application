//
//  GameViewModel.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 18.12.2022.
//

import Foundation
import UIKit

protocol GameViewModelProtocol {
    var sortOptions:[SortOptions] {get set}
    var genreList:[GenreModel] { get set }
    var selectedFilter : String { get set }
    var selectedSearch : String { get set }
    var delegate: GameViewModelDelegate? { get set }
    func fetchScrolledGame(tableView:UITableView)
    func setupGenreOptions()
    func getFilteredGames(tableView:UITableView)
    func getAllGames(tableView:UITableView)
    func getAllGameWithActivity(_ activityView: UIActivityIndicatorView,tableView:UITableView)
    
}
protocol GameViewModelDelegate:AnyObject{
    var isLoading:Bool { get set }
}

class GameViewModel : GameViewModelProtocol {
    
    var genreList: [GenreModel] = []
    
    weak var delegate: GameViewModelDelegate?
    
    var page = 1
    
    var selectedFilter : String = ""
    
    var selectedSearch : String = ""
    
    var selectedLanguage : String = "en"
    
    var notificationManager : NotificationManagerProtocol
    
    init(){
        notificationManager = NotificationManager()
        notificationManager.registerForPushNotifications()
        notificationManager.scheduleNotification(notificationType: "Hello")
    }
    
    var sortOptions:[SortOptions] = [SortOptions.noOrder(label: ""),SortOptions.name(label: "Name"), SortOptions.releaseDate(label: "Release Date"), SortOptions.rating(label: "Rating")]
    
    
    func getAllGameWithActivity(_ activityView: UIActivityIndicatorView,tableView:UITableView) {
        Client.getGames(page:page) { res, error in
            if let res = res {
                activityView.stopAnimating()
                GamesViewController.games = res.results
                tableView.reloadData()
            }
        }
    }
    
    func fetchScrolledGame(tableView:UITableView) {
        page += 1
        Client.getSearchedAndFilteredGames(page: page, game: selectedSearch, genre: selectedFilter) {
            [weak self] res, error in
            guard let self = self else { return }
            GamesViewController.games.append(contentsOf: res != nil ? res!.results : [])
            tableView.reloadData()
            self.delegate!.isLoading=false
        }
    }
    
    func handleGenreOptionsResponse(_ res: ResultModel?, _ self: GameViewModel) {
        if let res = res {
            var noGenre = GenreModel()
            noGenre.name = "All Games"
            noGenre.slug = ""
            noGenre.id = 0
            self.genreList.append(noGenre)
            self.genreList.append(contentsOf: res.results)
        }
    }
    
    func setupGenreOptions() {
        Client.getGenreOptions { [weak self] res, error in
            guard let self = self else { return }
            self.handleGenreOptionsResponse(res, self)
        }
    }
    
    func getAllGames(tableView:UITableView) {
        page = 1
        Client.getGames(page: page) { res, error in
            GamesViewController.games = res!.results
            tableView.reloadData()
        }
    }
    func getFilteredGames(tableView:UITableView) {
        page = 1
        Client.getSearchedAndFilteredGames(page: page, game:selectedSearch , genre: selectedFilter) {
            res, error in
            GamesViewController.games = res!.results
            tableView.reloadData()
        }
    }
    
}


enum SortOptions {
    case noOrder(label:String)
    case name(label : String)
    case releaseDate(label : String)
    case rating(label : String)
    
    
    var sortedList : [GameModel] {
        switch self {
        case .name(label: let name):
            return GamesViewController.games.sorted { $0.name! < $1.name! }
        case .releaseDate(label : let name):
            return GamesViewController.games.sorted { $0.released! < $1.released! }
        case .rating(label:let name):
            return GamesViewController.games.sorted { $0.rating! < $1.rating! }
        case .noOrder(label: let label):
            return GamesViewController.games
        }
    }
    var label : String {
        switch self {
        case .name(label: let name):
            return name
        case .rating(label: let name):
            return name
        case .releaseDate(label: let name):
            return name
        case .noOrder(label: let name):
            return name
        }
    }
}


