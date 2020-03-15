//
//  FavoritesViewController.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/13/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import UIKit
import MapKit

protocol FavoritesDelegate: class {
    func reconfigureMap(place: Place)
}

class FavoritesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet weak var closeOutButton: UIButton!
    @IBOutlet weak var favoritesTableView: UITableView!

    
    var favoritesArray: [Place]!
    var selectedPlace: Place!
    weak var delegate : FavoritesDelegate!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.favoritesTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell
        let place = self.favoritesArray[indexPath.row]
        cell?.cellSubtitle.text = self.favoritesArray[indexPath.row].longDescription
        cell?.cellTitle.text = self.favoritesArray[indexPath.row].name
        return cell!
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: {
            self.delegate.reconfigureMap(place: self.favoritesArray[indexPath.row])})
    }

}


