//
//  MarkersResponseModel.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 19/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation

struct Marker {
    let name: String
    let coordinates: [Double]
}

struct Markers {
    var markers: [Marker]
}

extension Markers {
    init?(json: [String: Any]) {
        
        guard let markersJSON = json["markers"] as? [[String: Any]] else { return nil }
    
        var markersObtanied: [Marker] = []
        
        for markerJSON in markersJSON {
            
            if let name = markerJSON["name"] as? String,
                let coordinates = markerJSON["coordinates"] as? [Double] {
                let newMarker = Marker.init(name: name, coordinates: coordinates)
                markersObtanied.append(newMarker)
            }
        }
        
        self.markers = markersObtanied
    }
}
