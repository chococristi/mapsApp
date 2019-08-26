//
//  POIMarkers.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 26/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation

/// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!

    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}

struct POIMarkers {
    var poiMarkers: [POIItem]
}

extension POIMarkers {
    init?(json: [String: Any]) {

        guard let markersJSON = json["markers"] as? [[String: Any]] else { return nil }

        var poiMarkersObtanied: [POIItem] = []

        for markerJSON in markersJSON {

            if let name = markerJSON["name"] as? String,
                let coordinates = markerJSON["coordinates"] as? [Double] {
                if let latitude = coordinates.first,
                    let longitude = coordinates.last {
                    let newPOIMarker = POIItem(position: CLLocationCoordinate2DMake(latitude,
                                                                                    longitude),
                                               name: name)
                    poiMarkersObtanied.append(newPOIMarker)
                }
            }
        }

        self.poiMarkers = poiMarkersObtanied
    }
}
