//
//  ContentView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/20/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isPickerPresented = false
    @State private var isCameraPresented = false
    @State private var isResultsViewPresented = false
    @State private var language: String = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "EN"
    
    let languages = ["EN", "BG", "JP", "ES", "FR"] // Add other languages as needed

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Language", selection: $language) {
                    ForEach(languages, id: \.self) { lang in
                        Text(lang).tag(lang)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: language) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "selectedLanguage")
                }
                .padding()

                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                } else {
                    Text("No Image Selected")
                        .foregroundColor(.gray)
                        .frame(height: 300)
                }

                Button(action: {
                    isPickerPresented = true
                }) {
                    Text("Select Image from Library")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isPickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }

                Button(action: {
                    isCameraPresented = true
                }) {
                    Text("Take Photo with Camera")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isCameraPresented) {
                    CameraView(selectedImage: $selectedImage)
                }

                if selectedImage != nil {
                    NavigationLink(destination: ResultsView(selectedImage: selectedImage!, language: language), isActive: $isResultsViewPresented) {
                        Button(action: {
                            isResultsViewPresented = true
                        }) {
                            Text("Analyze Image")
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
