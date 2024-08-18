//
//  Face.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class Face {
    let id = UUID()
    var name: String
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    
    @Attribute(.externalStorage) var photo: Data

    init(name: String, timestamp: Date, latitude: Double, longitude: Double, photo: Data) {
        self.name = name
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.photo = photo
    }
}
