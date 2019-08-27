//
//  MarkersResponseModel.swift
//  mapsApp
//
//  Created by Cristina Saura Pérez on 19/07/2019.
//  Copyright © 2019 Cristina Saura Pérez. All rights reserved.
//

import Foundation
import UIKit

struct Marker: Decodable {
    let name: String
    let coordinates: [Double]
    let cars: [Car]
}

struct Car: Decodable {
    let brand : String
    let model : String
    let year : String
    let image: String
}

let markers: [Marker] = load("bcnlocations.json")

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
