//
//  EditFace.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//

import SwiftData
import SwiftUI
import PhotosUI
import MapKit

struct EditFace: View {
    @Bindable var face: Face
    @State private var photo: PhotosPickerItem?
    @State private var processedImage: Image?
    
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false
    
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
    )
    
    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $face.name)
                PhotosPicker(selection: $photo, matching: .images) {
                    if let processedImage {
                        VStack {
                        processedImage
                            .resizable()
                            .scaledToFit()
                        Text("Added \(face.timestamp.formatted())")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                           
                    } else {
                        ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import face"))
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Edit Face")
            .onAppear(perform: loadInitialView)
            .onChange(of: photo) {
                saveImage()
                loadImage()
            }
            .alert(errorMessage, isPresented: $showingErrorAlert) {}
            
            if let processedImage {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        Annotation(face.name, coordinate: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude)) {
                            processedImage
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 40, height: 40)
                                .clipShape(.circle)
                        }
                    }
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            face.latitude = coordinate.latitude
                            face.longitude = coordinate.longitude
                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            startPosition = MapCameraPosition.region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: face.latitude, longitude: face.longitude),
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            )
        })
       
       
   }
    
    func saveImage() {
        Task {
            if let loaded = try? await photo?.loadTransferable(type: Data.self) {
                face.photo = loaded
                face.timestamp = .now
            } else {
                errorMessage = "Failed to load photo"
                showingErrorAlert = true
            }
        }
    }
    
    func loadInitialView() {
        guard let inputImage = UIImage(data: face.photo) else { return }
        processedImage = Image(uiImage: inputImage)
    }
    
    
    func loadImage() {
        Task {
            guard let imageData = try await photo?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            processedImage = Image(uiImage: inputImage)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Face.self, configurations: config)
    let face = Face(name: "Adam", timestamp: .now, latitude: 36.33233151, longitude: -122.0312186, photo: Data())
    
    return EditFace(face: face)
        .modelContainer(container)
    
}
