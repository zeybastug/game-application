//
//  NotesViewController.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 8.12.2022.
//

import UIKit
import CoreData


final class NoteViewController: BaseViewController {
    
    @IBOutlet weak var noteListTableView: UITableView!
    var notes: [Note] = []
    
    @IBOutlet weak var addNoteButton: UIButton!
    
    var cellSpacingHeight:CGFloat = 10 // TableView Cell Space
    
    private let floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        
        let image = UIImage (systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width-60, y: view.frame.size.height-175, width: 60, height: 60)
    }
    
    fileprivate func createNewNoteView() -> NewNoteViewModel {
        let newNoteView = NewNoteViewModel(frame: CGRect(origin: CGPointMake(view.center.x - 150, view.center.y - 300), size: CGSize(width: 300, height: 400)))
        newNoteView.alpha = 0
        UIView.animate(withDuration: 2.0) {
            newNoteView.alpha = 1
        }
        newNoteView.delegate = self
        
        return newNoteView
    }
    
    @objc private func didTapButton(){
        var newNoteView = createNewNoteView()
        view.addSubview(newNoteView)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNoteButton.isEnabled = false
        addNoteButton.layer.cornerRadius = 5
        self.noteListTableView.backgroundColor = UIColor(named: "naviColor")
        
        notes = CoreDataManager.shared.getNotes()
        configureTableView()
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        noteListTableView.addSubview(floatingButton)
    }
    
    private func configureTableView() {
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        noteListTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.items![0].title =         navigationController?.navigationBar.items![0].title?.localizableString(GamesViewController.selectedLanguage)
    }
    
    
    
    @IBAction func addNoteAction(_ sender: Any) {
        var newNoteView = createNewNoteView()
        view.addSubview(newNoteView)
    }
    
    
}

extension NoteViewController: NewNoteViewDelegate {
    
    
    
    func saveUpdatePressed(note:Note,name:String,noteText:String) {
        notes = []
        CoreDataManager.shared.updateNote(note: note,name: name,noteText: noteText)
        notes = CoreDataManager.shared.getNotes()
        noteListTableView.reloadData()
    }
    
    func savePressed(input: String, name:String, id:Int64) {
        notes.append(CoreDataManager.shared.saveNote(text: input, name:name,id: id)!)
        noteListTableView.reloadData()
    }
}

extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell else {
            
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(named: "cellColor")
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.configureCell(model: notes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteView = createNewNoteView()
        noteView.id = notes[indexPath.row].id
        noteView.selectGameTextView.text = notes[indexPath.row].name
        noteView.newNoteTextView.text = notes[indexPath.row].noteText
        noteView.isUpdate = true
        noteView.note = notes[indexPath.row]
        view.addSubview(noteView)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        CoreDataManager.shared.deleteNote(note: notes[indexPath.row])
        notes = CoreDataManager.shared.getNotes()
        noteListTableView.reloadData()
    }
    
    
}
