//
//  NameFaceApp.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//

import SwiftData
import SwiftUI

@main
struct NameFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Face.self)
        }
    }
}
