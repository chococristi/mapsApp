//
//  GMSMapViewExtensions.swift
//  mapsApp
//
//  Created by Carles Cañades Torrents on 22/08/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import GoogleMaps

private struct MapPath : Decodable {
    var routes : [Route]?
}

private struct Route : Decodable {
    var overviewPolyline : OverView?

    enum CodingKeys: String, CodingKey {
        case overviewPolyline = "overview_polyline"
    }
}

private struct OverView : Decodable {
    var points : String?
}

extension GMSMapView {

    // MARK: - Call API for polygon points

    func drawPolygon(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude)," +
            "\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)" +
            "&sensor=false&mode=driving&key=AIzaSyAdE8r0bQcPQfye1dC_LKX16OWIuqPvYmU") else {
            return
        }

        DispatchQueue.main.async {

            session.dataTask(with: url) { (data, _, error) in

                guard data != nil else {
                    return
                }
                do {

                    let route = try JSONDecoder().decode(MapPath.self, from: data!)

                    if let points = route.routes?.first?.overviewPolyline?.points {
                        self.drawPath(with: points)
                    }
                    print(route.routes?.first?.overviewPolyline?.points as Any)

                } catch let error {

                    print("Failed to draw ",error.localizedDescription)
                }
                }.resume()
        }
    }

    // MARK: - Draw polygon

    private func drawPath(with points : String) {

        DispatchQueue.main.async {

            let path = GMSPath(fromEncodedPath: points)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.strokeColor = .red
            polyline.map = self

        }
    }
}
