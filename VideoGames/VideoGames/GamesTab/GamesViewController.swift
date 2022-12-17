//
//  ViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit
import Kingfisher
enum SortOptions {
    case noOrder(label:String)
    case name(label : String)
    case releaseDate(label : String)
    case rating(label : String)
    
    
    var sortedList : [GameModel] {
        switch self {
        case .name(label: let name):
            return GamesViewController.games!.sorted { $0.name! < $1.name! }
        case .releaseDate(label : let name):
            return GamesViewController.games!.sorted { $0.released! < $1.released! }
        case .rating(label:let name):
            return GamesViewController.games!.sorted { $0.rating! < $1.rating! }
        case .noOrder(label: let label):
            return GamesViewController.games!
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

class GamesViewController: BaseViewController {
    
    
    
    @IBOutlet weak var filterTextField: UITextField!
    
    @IBOutlet weak var sortTextField: UITextField!
    
    @IBOutlet weak var filterGamesButton: UIBarButtonItem!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.dataSource = self
            gamesTableView.delegate = self
        }
    }
    
    var sortOptions:[SortOptions] = [SortOptions.noOrder(label: ""),SortOptions.name(label: "Name"), SortOptions.releaseDate(label: "Release Date"), SortOptions.rating(label: "Rating")]
    
    var genreList:[GenreModel] = []
  
    public static var games: [GameModel]?
    
    var pickerView = UIPickerView()
    
    var page = 0
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGenreOptions()
        filterTextField.delegate = self
        sortTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        filterTextField.inputView = pickerView
        sortTextField.inputView = pickerView
        FavouritesViewController.favouriteList = CoreDataManager.shared.getFavourites()
        getGames()
            
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (gamesTableView.contentSize.height-scrollView.frame.size.height) {
            if (isLoading) {
                return
            }
            page+=1
            if(filterTextField.text != ""){
                
            }
            else if(searchTextField.text != ""){
                
            }else{
                
            }
        }
    }
    
    
    func getGames() {
        
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        Client.getGames(page:page) { [weak self] res, error in
            activityView.stopAnimating()
            guard let self = self else { return }
            GamesViewController.games = res?.results
            self.gamesTableView.reloadData()

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    

    func setupGenreOptions() {
        Client.getGenreOptions { [weak self] res, error in
            guard let self = self else { return }
            var noGenre = GenreModel()
            noGenre.name = "All Games"
            noGenre.slug = ""
            noGenre.id = 0
            self.genreList.append(noGenre)
            self.genreList.append(contentsOf: res!.results)
        }
    }
    

    @IBAction func searchButton(_ sender: Any) {
        
        let replaced = searchTextField.text!.replacingOccurrences(of: " ", with: "-")
        Client.getSearchedGames(page:page, game: replaced)
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
            }))!){
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

// MARK: - TextField Extention
extension GamesViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        pickerView.tag = textField.tag
        return true
    }
 
    
}

extension GamesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 0 ? sortOptions.count : genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? sortOptions[row].label : genreList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0)
        {
            GamesViewController.games = sortOptions[row].sortedList
            sortTextField.text = sortOptions[row].label
            gamesTableView.reloadData()
            sortTextField.resignFirstResponder()
            
        } else if (pickerView.tag == 1)
        {
            GamesViewController.games = []
            filterTextField.text = genreList[row].name
            if (genreList[row].name == "All Games")
            {
                Client.getGames(page: page) { [weak self] res, error in
                    guard let self = self else { return }
                    GamesViewController.games = res?.results
                    self.gamesTableView.reloadData()
                }
            } else {
                Client.getGamesByGenre(page:page, genre: genreList[row].slug!)
                { [weak self] res, error in
                    guard let self = self else { return }
                    GamesViewController.games = res?.results
                    self.gamesTableView.reloadData()
                }
            }
            filterTextField.resignFirstResponder()
        }
    }
    
}
