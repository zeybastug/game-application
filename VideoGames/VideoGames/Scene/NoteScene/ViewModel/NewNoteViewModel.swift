//
//  NewNoteView.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//

import UIKit
import CoreData

protocol NewNoteViewDelegate: AnyObject {
    func savePressed(input: String, name:String,id:Int64)
    func saveUpdatePressed(note:Note,name:String,noteText:String)
}

protocol SaveButtonDelegate:AnyObject {
    func noteSaved()
}

final class NewNoteViewModel: UIView, UITextViewDelegate {
    
    var saveButtonDelegate:SaveButtonDelegate?
    
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet{
            
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.isHidden = true
        }
    }
    var isUpdate:Bool = false
    
    var note:Note?
    
    var id : Int64?
    
    @IBOutlet weak var newNoteTextView: UITextView!
    
    @IBOutlet weak var selectGameTextView: UITextView!{
        didSet{
            selectGameTextView.delegate = self
        }
    }
    
    weak var delegate: NewNoteViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        let nib = UINib(nibName: "NewNoteView", bundle: nil)
        if let view = nib.instantiate(withOwner: self).first as? UIView {
            addSubview(view)
            view.frame = self.bounds
        }
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !isUpdate {
            if let name = selectGameTextView.text, name != "",
               let note = newNoteTextView.text, note != "" {
                delegate?.savePressed(input: newNoteTextView.text, name:selectGameTextView.text,id: id!)
                removeFromSuperview()
                
            } else {
                AlertManager.shared.showAlert(with: .emptyInput)
            }
        } else {
            
            if let name = selectGameTextView.text, name != "",
               let note = newNoteTextView.text, note != "" {
                delegate?.saveUpdatePressed(note: self.note!,name: name,noteText: note)
                removeFromSuperview()
            } else {
                AlertManager.shared.showAlert(with: .emptyInput)
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        pickerView.isHidden = false
        return false
    }
    
    
    @IBAction func closeNewNoteView(_ sender: Any) {
        removeFromSuperview()
        
    }
    
}


extension NewNoteViewModel : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GamesViewController.games.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GamesViewController.games[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the user selecting a row in the picker view.
        selectGameTextView.text = GamesViewController.games[row].name
        id = Int64(GamesViewController.games[row].id!)
        pickerView.isHidden=true
    }
}
