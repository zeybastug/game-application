//
//  ViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit
import Kingfisher

class GamesViewController: BaseViewController {
    
    @IBOutlet weak var filterGamesButton: UIBarButtonItem!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.dataSource = self
            gamesTableView.delegate = self
        }
    }
    
    //    var isLoading = true
    //    var lastPage = 1
    
    public static var games: [GameModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavouritesViewController.favouriteList = CoreDataManager.shared.getFavourites()
        Client.getGames { [weak self] res, error in
            guard let self = self else { return }
            GamesViewController.games = res?.results
            self.gamesTableView.reloadData()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupMenu()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetails") {
            if let detailsVC = segue.destination as? DetailsViewController {
                if let game = sender as? GameModel {
                    detailsVC.gameModel = game
                    
                }
            }
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        let position = scrollView.contentOffset.y
    //        if position > (gamesTableView.contentSize.height-scrollView.frame.size.height) {
    //            if (isLoading) {
    //                return
    //            }
    //            lastPage+=1
    //            Client.getGames { [weak self] res, error in
    //                guard let self = self else { return }
    //                getData(url:"https://api.nasa.gov/mars-photos/api/v1/rovers/" + tab[AppDelegate.selectedIndex] + "/photos?sol=" + String(self.sol.value) + "&page=" + String(lastPage) + "&api_key=DEMO_KEY")
    //            }
    //        }
    
    func setupMenu() {
        
        var genreList:[UIAction] = []
        
        let noFilter = UIAction(title: "No Filter", image: UIImage(systemName: "minus"), attributes: .destructive) {
            (action) in
            genreList = []
            Client.getGames { [weak self] res, error in
                guard let self = self else { return }
                GamesViewController.games = res?.results
                self.gamesTableView.reloadData()
            }
        }
        
        Client.getGenreOptions { [weak self] res, error in
            res?.results.forEach({ genreModel in
                let action = UIAction(title: genreModel.name!, image: UIImage(systemName: "plus")) { (action) in
                    GamesViewController.games = []
                    Client.getGenres(genre: genreModel.slug!)
                    { [weak self] res, error in
                        guard let self = self else { return }
                        GamesViewController.games = res?.results
                        self.gamesTableView.reloadData()
                    }
                }
                
                genreList.append(action)
                genreList.insert(noFilter, at: 0)
                
            })
            
            let menu = UIMenu(title: "Filter", children: genreList)
            self!.filterGamesButton.menu = menu
        }
    }
    

    @IBAction func searchButton(_ sender: Any) {
        
        let replaced = searchTextField.text!.replacingOccurrences(of: " ", with: "-")
        Client.getSearchedGames(game: replaced)
        { [weak self] res, error in
            guard let self = self else { return }
            GamesViewController.games = res?.results
            self.gamesTableView.reloadData()
        }
        
    }
    
}
    
    extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            GamesViewController.games?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameTableViewCell, let model = GamesViewController.games?[indexPath.row] else {
                return UITableViewCell()
            }
            
            if ((FavouritesViewController.favouriteList?.contains(where: { FavouriteGame in
                FavouriteGame.name == model.name
            })) != nil){
                cell.likeImageView.isHidden = false
            } else{
                cell.likeImageView.isHidden = true
            }
            cell.configureCell(model: model)

            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let gameCell = GamesViewController.games?[indexPath.row]
            performSegue(withIdentifier: "toDetails", sender: gameCell)
            gamesTableView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    

