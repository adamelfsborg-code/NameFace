//
//  Face.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//

import Foundation
import SwiftData

@Model
class Face {
    let id = UUID()
    var name: String
    var timestamp: Date
    @Attribute(.externalStorage) var photo: Data
    
    init(name: String, timestamp: Date, photo: Data) {
        self.name = name
        self.timestamp = timestamp
        self.photo = photo
    }
}
