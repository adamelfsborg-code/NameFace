//
//  ContentView.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//
import SwiftData
import SwiftUI
import PhotosUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query() var faces: [Face]
    @State private var path = NavigationPath()
    let locationFetcher = LocationFetcher()

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(faces) { face in
                    NavigationLink(value: face) {
                        HStack {
                            
                            Text(face.name)
                           
                            Spacer()
                           
                            if !face.photo.isEmpty {
                                Image(uiImage: UIImage(data: face.photo)!)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(15)
                            }
                          
                        }
                    }
                }
            }
            .navigationTitle("NameFace")
            .toolbar {
                Button("Import Face") {
                    let latitude = locationFetcher.lastKnownLocation?.latitude ?? 0
                    let longitude = locationFetcher.lastKnownLocation?.longitude ?? 0
                    
                    let face = Face(name: "", timestamp: .now, latitude: latitude, longitude: longitude, photo: Data())
                    modelContext.insert(face)
                    path.append(face)
                }
            }
            .navigationDestination(for: Face.self) { face in
                EditFace(face: face)
            }
        }
    }
    
    init() {
        locationFetcher.start()
    }
    
 
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Face.self, configurations: config)
    
    return ContentView()
        .modelContainer(container)
    
}
