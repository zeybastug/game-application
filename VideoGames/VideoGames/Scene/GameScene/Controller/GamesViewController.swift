//
//  ViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit
import Kingfisher

class GamesViewController: BaseViewController,GameViewModelDelegate {
    
    @IBOutlet weak var filterTextField: UITextField! {
        didSet {
            filterTextField.delegate = self
        }
    }
    
    @IBOutlet weak var sortTextField: UITextField! {
        didSet {
            sortTextField.delegate = self
        }
    }
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var filterGamesButton: UIBarButtonItem!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var gamesTableView: UITableView! {
        didSet {
            gamesTableView.dataSource = self
            gamesTableView.delegate = self
        }
    }
    
    var gameViewModel :GameViewModelProtocol = GameViewModel()
    
    public static var games: [GameModel] = []
    
    var pickerView : UIPickerView!{
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
    var page = 1
    
    var isLoading = false
    
    static var selectedLanguage = "en"
    
    var cellSpacingHeight:CGFloat = 10 // TableView Cell Space
    
    let activityView = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gamesTableView.backgroundColor = UIColor(named: "naviColor")
        
        gameViewModel.delegate = self
        pickerView = UIPickerView()
        gameViewModel.setupGenreOptions()
        filterTextField.inputView = pickerView
        sortTextField.inputView = pickerView
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
        gameViewModel.getAllGameWithActivity(activityView,tableView: gamesTableView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        FavouritesViewController.favouriteList = CoreDataManager.shared.getFavourites()
        gamesTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (gamesTableView.contentSize.height-scrollView.frame.size.height - 50) {
            if (isLoading) {
                return
            }
            isLoading = true
            gameViewModel.fetchScrolledGame(tableView: gamesTableView)
        }
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
    
    @IBAction func onSearchButton(_ sender: Any) {
        let replaced = searchTextField.text!.replacingOccurrences(of: " ", with: "-")
        gameViewModel.selectedSearch = replaced
        gameViewModel.getFilteredGames(tableView: gamesTableView)
    }
    
    
    @IBAction func changeLanguage(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 1:
            GamesViewController.selectedLanguage = "tr"
            tabBarController?.tabBar.items![0].title =  tabBarController?.tabBar.items![0].title!.localizableString("tr")
            tabBarController?.tabBar.items![1].title =  tabBarController?.tabBar.items![1].title!.localizableString("tr")
            tabBarController?.tabBar.items![2].title =  tabBarController?.tabBar.items![2].title!.localizableString("tr")
            navigationController?.navigationBar.items![0].title = navigationController?.navigationBar.items![0].title?.localizableString("tr")
            
            searchButton.titleLabel?.text = searchButton.titleLabel?.text?.localizableString("tr")
            searchTextField.text = searchTextField.text?.localizableString("tr")
            searchTextField.placeholder = searchTextField.placeholder?.localizableString("tr")
            filterTextField.text = filterTextField.text?.localizableString("tr")
            filterTextField.placeholder = filterTextField.placeholder?.localizableString("tr")
            sortTextField.text = sortTextField.text?.localizableString("tr")
            sortTextField.placeholder = sortTextField.placeholder?.localizableString("tr")
            view.reloadInputViews()
            gamesTableView.reloadData()
            pickerView.reloadAllComponents()
            
        case 0:
            GamesViewController.selectedLanguage = "en"
            tabBarController?.tabBar.items![0].title =  tabBarController?.tabBar.items![0].title!.localizableString("en")
            tabBarController?.tabBar.items![1].title =  tabBarController?.tabBar.items![1].title!.localizableString("en")
            tabBarController?.tabBar.items![2].title =  tabBarController?.tabBar.items![2].title!.localizableString("en")
            navigationController?.navigationBar.items![0].title = navigationController?.navigationBar.items![0].title?.localizableString("en")
            
            searchButton.titleLabel?.text = searchButton.titleLabel?.text?.localizableString("en")
            searchTextField.text = searchTextField.text?.localizableString("en")
            searchTextField.placeholder = searchTextField.placeholder?.localizableString("en")
            filterTextField.text = filterTextField.text?.localizableString("en")
            filterTextField.placeholder = filterTextField.placeholder?.localizableString("en")
            sortTextField.text = sortTextField.text?.localizableString("en")
            sortTextField.placeholder = sortTextField.placeholder?.localizableString("en")
            view.reloadInputViews()
            gamesTableView.reloadData()
            pickerView.reloadAllComponents()
        default:
            break
        }
    }
}

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        GamesViewController.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = gamesTableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
        
        cell.backgroundColor = UIColor(named: "cellColor")
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        
        if ((FavouritesViewController.favouriteList?.contains(where: { FavouriteGame in
            FavouriteGame.name == GamesViewController.games[indexPath.row].name
        }))!){
            cell.likeImageView.isHidden = false
        } else{
            cell.likeImageView.isHidden = true
        }
        cell.configureCell(model: GamesViewController.games[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameCell = GamesViewController.games[indexPath.row]
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
        return pickerView.tag == 0 ? gameViewModel.sortOptions.count : gameViewModel.genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 0 ? gameViewModel.sortOptions[row].label.localizableString(GamesViewController.selectedLanguage) : gameViewModel.genreList[row].name?.localizableString(GamesViewController.selectedLanguage)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0)
        {
            GamesViewController.games = gameViewModel.sortOptions[row].sortedList
            sortTextField.text = gameViewModel.sortOptions[row].label
            gamesTableView.reloadData()
            sortTextField.resignFirstResponder()
            
        } else if (pickerView.tag == 1)
        {
            GamesViewController.games = []
            filterTextField.text = gameViewModel.genreList[row].name
            if (gameViewModel.genreList[row].name == "All Games")
            {
                gameViewModel.getAllGames(tableView: gamesTableView)
            } else {
                gameViewModel.selectedFilter = gameViewModel.genreList[row].slug!
                gameViewModel.getFilteredGames(tableView: gamesTableView)
            }
            filterTextField.resignFirstResponder()
        }
    }
    
}

extension String {
    
    func localizableString(_ name: String) -> String {
        let path = Bundle.main.path(forResource: name, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
