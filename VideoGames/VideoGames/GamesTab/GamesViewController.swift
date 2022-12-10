//
//  ViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit

class GamesViewController: BaseViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.dataSource = self
            gamesTableView.delegate = self
        }
    }
    
    private var games: [GameModel]? {
        didSet {
            gamesTableView.reloadData()
        }
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            
            Client.getGames { [weak self] res, error in
                guard let self = self else { return }
                self.games = res?.results
                
            }
            
            
        }
    }


extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as? GameTableViewCell, let model = games?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.likeImageView.isHidden = true

        cell.configureCell(model: model)
        return cell
        
        
    }
    
    
}



