//
//  PlaceMarkerView.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/6/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {
    
    static var customID = "custompin"
    
  override var annotation: MKAnnotation? {
      willSet {
        isHidden = false
        canShowCallout = true
        clusteringIdentifier = "Place"
        displayPriority = .defaultLow
        markerTintColor = .systemTeal
        glyphImage = UIImage(systemName: "star")
        }
  }
    


}
