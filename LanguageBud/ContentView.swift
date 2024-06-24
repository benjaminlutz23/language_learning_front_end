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
    @State private var isReviewMissedWordsViewPresented = false
    @State private var selectedLanguage: String = "English"

    let languages = [
        "English": "EN",
        "Bulgarian": "BG",
        "Japanese": "JA",
        "Spanish": "ES",
        "French": "FR",
        "Chinese (Simplified)": "ZH",
        "Danish": "DA",
        "Dutch": "NL",
        "German": "DE",
        "Greek": "EL",
        "Hungarian": "HU",
        "Italian": "IT",
        "Polish": "PL",
        "Portuguese": "PT",
        "Romanian": "RO",
        "Russian": "RU",
        "Slovak": "SK",
        "Slovenian": "SL",
        "Swedish": "SV"
    ]

    var body: some View {
        NavigationStack {
            VStack {
                DropdownView(
                    title: "Select Language",
                    prompt: "Select",
                    options: Array(languages.keys.sorted())
                ) { selected in
                    selectedLanguage = selected
                }
                .padding(.horizontal)
                
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
                    Button(action: {
                        isResultsViewPresented = true
                    }) {
                        Text("Analyze Image")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .navigationDestination(isPresented: $isResultsViewPresented) {
                        ResultsView(selectedImage: selectedImage!, language: languages[selectedLanguage] ?? "EN")
                    }
                }

                Button(action: {
                    isReviewMissedWordsViewPresented = true
                }) {
                    Text("Review Missed Words")
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .navigationDestination(isPresented: $isReviewMissedWordsViewPresented) {
                    ReviewMissedWordsView(language: languages[selectedLanguage] ?? "EN")
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
