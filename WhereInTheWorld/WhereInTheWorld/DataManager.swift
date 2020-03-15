//
//  DataManager.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/13/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import Foundation

public class DataManager {
    
    // MARK: - Singleton Stuff
    public static let sharedInstance = DataManager()
    var placesArray = [Place]()
    var favoritesArray = [Place]()
    
    //This prevents others from using the default '()' initializer
    fileprivate init() {
        print("Called INIT in datamanager")
        self.loadPlacesFromMem()
        self.loadFavorites()
        self.unifyFavorites()
    }
    
    // Your code (these are just example functions, implement what you need)
    func loadAnnotationFromPlist() {}
    
    
    func loadPlacesFromMem() {
        let dataSource: URL  = Bundle.main.url(forResource: "Data", withExtension: "plist")!
        var places: [Place]?
        
        if let data = try? Data(contentsOf: dataSource) {
            let decoder = PropertyListDecoder()
            places = try? decoder.decode(TestObject.self, from: data).places
            self.placesArray = places!
        }
    }
    func saveFavorites(favorites: [Place]) {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: favorites, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "favoritePlaces")
            
        }
    }
    
    func loadFavorites() {
        let defaults = UserDefaults.standard
        if let savedFavorites = defaults.object(forKey: "favoritePlaces") as? Data {
            if let decodedFavorites = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedFavorites) as? [Place] {
                self.favoritesArray = decodedFavorites
                self.favoritesArray.forEach({$0.isFavorited=true})
            }
        }
    }
    
    func saveFavorites() {
        self.saveFavorites(favorites: self.favoritesArray)
    }
    
    func deleteFavorite(favorite: Place) {
        for fav in self.favoritesArray {
            if fav == favorite {
                favoritesArray.remove(at: favoritesArray.firstIndex(of: fav)!)
            }
        }
    }
    
    func addFavorite(favorite: Place) {
        if !self.isDuplicate(place: favorite) {
            favorite.isFavorited = true
            self.favoritesArray.append(favorite)
        }
        self.saveFavorites()
    }
    
    func listFavorites() -> [Place]{
        if self.favoritesArray.count == 0 {
            self.loadFavorites()
        }
        return self.favoritesArray
    }
    
    func listAllPlaces() -> [Place]{
        if self.placesArray.count == 0 {
            self.loadPlacesFromMem()
        }
        return self.placesArray
    }
    
    func isDuplicate(place: Place) -> Bool {
        for favorite in self.favoritesArray {
            if favorite == place {
                return true
            }
        }
        return false
    }
    
    func unifyFavorites() {
        if favoritesArray.isEmpty {
            loadFavorites()
        }
        if placesArray.isEmpty {
            loadPlacesFromMem()
        }
        for place in self.placesArray {
            for fav in favoritesArray {
                if place == fav {
                    place.isFavorited = true
                }
            }
            
        }
    }
    
    func deleteAllFavorites() {
        self.favoritesArray = [Place]()
        self.saveFavorites()
    }
    
    func isFavorited(place: Place) -> Bool {
        for fav in favoritesArray {
            if place == fav {
                return true
            }
        }
        return false
    }
}
