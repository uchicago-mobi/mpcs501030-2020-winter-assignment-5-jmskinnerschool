//
//  ViewController.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/6/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import UIKit
import MapKit



class MapViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView! {didSet { mapView.delegate = self }}
    @IBOutlet weak var pointOfIntView: UIView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationDescription: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    private var placesArray: [Place]!
    private var favoritesArray: [Place]!
    var dataManager = DataManager.sharedInstance
    
    @IBAction func starButtonTapped(_ sender: Any) {
        for place in self.placesArray {
            if place.name == self.locationTitle.text && place.longDescription == self.locationDescription.text {
                if starButton.isSelected {
                    self.dataManager.deleteFavorite(favorite: place)
                    self.starButton.isSelected = false
                    print("I removed a favorite!")
                } else {
                    print("I added a favorite!")
                    self.dataManager.addFavorite(favorite: place)
                    self.starButton.isSelected = true
                }
            }
        }
        dataManager.saveFavorites()
        dataManager.loadFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.bringSubviewToFront(self.pointOfIntView)
        self.view.bringSubviewToFront(self.favoritesButton)
        let miles: Double = 1 * 1600
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        let zoomLocation = CLLocationCoordinate2DMake(41.930340, -87.702840)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation,
                                                 latitudinalMeters: miles, longitudinalMeters: miles)
        mapView.setRegion(viewRegion, animated: true)
        self.configureDataSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placesArray = self.dataManager.placesArray
        self.favoritesArray =  self.dataManager.favoritesArray
        self.mapView.delegate = self
        self.mapView.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: "custompin")
        for place in self.placesArray! {
            place.coordinate = CLLocationCoordinate2D(latitude: place.lat!, longitude: place.long!)
            place.title = place.name
            place.subtitle = place.longDescription
        }
        self.mapView.addAnnotations(self.placesArray!)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "transitionToFavoritesTable", sender: self)
    }
    
    func configureDataSource() {
        self.dataManager.loadPlacesFromMem()
        self.dataManager.loadFavorites()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FavoritesViewController
        vc.favoritesArray = self.dataManager.listFavorites()
        vc.delegate = self
    }
    
}

extension MapViewController: FavoritesDelegate{
    func reconfigureMap(place: Place) {
        locationTitle.text = place.name
        locationDescription.text = place.subtitle
        let miles: Double = 1 * 1600
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        let zoomLocation = CLLocationCoordinate2DMake(place.lat!, place.long!)
        let viewRegion = MKCoordinateRegion.init(center: zoomLocation,latitudinalMeters: miles, longitudinalMeters: miles)
        self.mapView.setRegion(viewRegion, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.locationTitle.text = view.annotation?.title!
        self.locationDescription.text = view.annotation?.subtitle!
        self.starButton.isSelected = dataManager.isFavorited(place: view.annotation as! Place)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "CustomPin"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = PlaceMarkerView()
            view.annotation = annotation
            view.canShowCallout = true
        }
        return view
    }
}


