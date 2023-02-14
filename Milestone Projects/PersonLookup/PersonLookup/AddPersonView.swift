//
//  AddPersonView.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

import SwiftUI
import CoreLocation
import MapKit

struct AddPersonView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = ViewModel()
    
    var person: Person
    
    @State private var image: Image?
    @State private var inputUIImage: UIImage?
    @State private var savingUIImage: UIImage?
    @State private var showingImagePicker = false
    @State private var contactName = ""
    @State private var locationName = ""
    @State private var coordinate: CLLocationCoordinate2D
    
    @State private var showingEmptyNameAlert = false
    @State private var showingSaveError = false
    
    //    init(viewModel: ViewModel) {
    //            self.viewModel = viewModel
    //        }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Photo")) {
                        ZStack {
                            Rectangle()
                                .fill(.secondary)
                                .frame(width: 300, height: 300)
                            Text("Tap to select a photo")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            image?
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        .onTapGesture {
                            showingImagePicker = true
                        }
                    }
                    
                    Section(header: Text("Type")) {
                        TextField("Enter location type", text: $contactName)
                        //.textFieldStyle(.roundedBorder)
                    }
                    
                    Section(header: Text("Location")) {
                        VStack {
                            TextField("Enter location name", text: $locationName)
                            HStack {
                                Button("Track Location") {
                                    viewModel.locationFetcher.start()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Button("Read Location") {
                                    coordinate = viewModel.locationFetcher.lastKnownLocation ?? CLLocationCoordinate2D(latitude: -38, longitude: -123)
                                    
                                    print(coordinate)
                                }
                            }
                        }
                    }
                }
            }
            .onChange(of: inputUIImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputUIImage)
            }
            .alert(isPresented: $showingEmptyNameAlert, content: {
                Alert(title: Text("Please provide a name"))
            })
            // add an alert modifier when image is tried to save
            .alert("Oops!", isPresented: $showingSaveError) {
                Button("OK") { }
            } message: {
                Text("Sorry, there was an error saving your image – please check that you have allowed permission for this app to save photos.")
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        viewModel.addNewPerson(name: contactName, inputUIImage: savingUIImage, locationName: locationName, latitude: coordinate.latitude, longitude: coordinate.longitude)
                        dismiss()
                    }
                    .disabled(inputUIImage == nil)
                    .disabled(contactName == "")
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputUIImage = inputUIImage else { return }
        image = Image(uiImage: inputUIImage)
        savingUIImage = inputUIImage
    }
    
    init(person: Person) {
        self.person = person
        
        _coordinate = State(initialValue: person.coordinate)
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView(person: Person.example)
    }
}
