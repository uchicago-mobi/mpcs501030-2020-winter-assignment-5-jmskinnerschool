//
//  Place.swift
//  WhereInTheWorld
//
//  Created by Jake Skinner on 3/6/20.
//  Copyright © 2020 Jake Skinner. All rights reserved.
//

import Foundation
import MapKit

class TestObject: Codable {
    var places: [Place]
}

class Place: MKPointAnnotation, Codable, NSCoding {
    
    var name: String?
    var lat: Double?
    var long: Double?
    var type: Int?
    var longDescription: String?
    var isFavorited = false
    private enum CodingKeys : String, CodingKey {
        case longDescription = "description"
        case name, lat, long, type
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(lat, forKey: "lat")
        coder.encode(long, forKey: "long")
        coder.encode(type, forKey: "type")
        coder.encode(longDescription, forKey:  "longDescription")
    }
    
    init(name: String?, longDescription: String?, lat: Double?, long: Double?, type: Int?) {
        super.init()
        self.name = name
        self.longDescription = longDescription
        self.lat = lat
        self.long = long
        self.type = type
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as? String ?? ""
        let longDescription = coder.decodeObject(forKey: "longDescription") as? String ?? ""
        let lat = coder.decodeObject(forKey: "lat") as? Double ?? 0.0
        let long = coder.decodeObject(forKey: "long") as? Double ?? 0.0
        let type = coder.decodeObject(forKey: "type") as? Int ?? 1
        
        self.init(name: name, longDescription: longDescription, lat: lat, long: long, type: type)
    }
    
}

extension Place {
    
    static func ==(lhs:Place,rhs:Place) -> Bool {
        return (lhs.name == rhs.name) && (lhs.longDescription == rhs.longDescription)
    }
    
    func isEqual(object: AnyObject?) -> Bool {
           guard let place = object as? Place else { return false }
           return self == place
       }
    
}
