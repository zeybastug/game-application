//
//  CoreDataManager.swift
//  VideoGames
//
//  Created by Zeynep Baştuğ on 10.12.2022.
//


import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let managedContext: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func saveNote(text: String, name:String,id:Int64) -> Note? {
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(text, forKeyPath: "noteText")
        note.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            return note as? Note
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func getNotes() -> [Note] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            let notes = try managedContext.fetch(fetchRequest)
            return notes as! [Note]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
    
    func updateNote(note:Note,name:String,noteText:String) {
        let fetchedNote = managedContext.object(with: note.objectID)
        fetchedNote.setValue(name, forKey: "name")
        fetchedNote.setValue(noteText, forKey: "noteText")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deleteNote(note:Note){
        
        let deletedNote = managedContext.object(with: note.objectID)
        managedContext.delete(deletedNote)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addToFavourites(name:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "FavouriteGame", in: managedContext)!
        let game = NSManagedObject(entity: entity, insertInto: managedContext)
        game.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteFav(fav:FavouriteGame){
        
        let deletedFav = managedContext.object(with: fav.objectID)
        managedContext.delete(deletedFav)
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getFavourites() -> [FavouriteGame] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteGame")
        do {
            let favs = try managedContext.fetch(fetchRequest)
            return favs as! [FavouriteGame]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return []
    }
}
