//
//  EditFace.swift
//  NameFace
//
//  Created by Adam Elfsborg on 2024-08-17.
//

import SwiftData
import SwiftUI
import PhotosUI

struct EditFace: View {
    @Bindable var face: Face
    @State private var photo: PhotosPickerItem?
    @State private var processedImage: Image?
    
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false
    
    var body: some View {
        Form {
            TextField("Name", text: $face.name)
            PhotosPicker(selection: $photo, matching: .images) {
                if let processedImage {
                    processedImage
                        .resizable()
                        .scaledToFit()
                    Text("Added \(face.timestamp.formatted())")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Import a photo to get started"))
                }
  
            }

        }
        .navigationTitle("Edit Face")
        .onAppear(perform: loadInitialView)
        .onChange(of: photo) {
            saveImage()
            loadImage()
        }
        .alert(errorMessage, isPresented: $showingErrorAlert) {}
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
    let face = Face(name: "Adam", timestamp: .now, photo: Data())
    return EditFace(face: face)
        .modelContainer(container)
    
}
