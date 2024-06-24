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
    @Environment(\.colorScheme) var scheme
    
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
            ZStack {
                VStack {
                    Spacer()
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Text("No Image Selected")
                            .foregroundColor(.gray)
                            .frame(height: 200)
                    }

                    if selectedImage != nil {
                        Button(action: {
                            isResultsViewPresented = true
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .padding()
                                .frame(width: 200, height: 50)
                                .background(.green)
                                .foregroundColor(scheme == .dark ? Color.black : Color.white)
                                .cornerRadius(10)
                                .shadow(color: .primary.opacity(0.5), radius: 4)
                        }
                        .navigationDestination(isPresented: $isResultsViewPresented) {
                            ResultsView(selectedImage: selectedImage!, language: languages[selectedLanguage] ?? "EN")
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isPickerPresented = true
                        }) {
                            Image(systemName: "photo.fill")
                                .padding()
                                .frame(width: 50, height: 50)
                                .background(scheme == .dark ? Color.black : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .shadow(color: .primary.opacity(0.5), radius: 4)
                        }
                        .sheet(isPresented: $isPickerPresented) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isReviewMissedWordsViewPresented = true
                        }) {
                            Text("Rev")
                                .padding()
                                .frame(width: 50, height: 50)
                                .background(scheme == .dark ? Color.black : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .shadow(color: .primary.opacity(0.5), radius: 4)
                        }
                        .navigationDestination(isPresented: $isReviewMissedWordsViewPresented) {
                            ReviewMissedWordsView(language: languages[selectedLanguage] ?? "EN")
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            isCameraPresented = true
                        }) {
                            Image(systemName: "camera.fill")
                                .padding()
                                .frame(width: 50, height: 50)
                                .background(scheme == .dark ? Color.black : Color.white)
                                .foregroundColor(.primary)
                                .cornerRadius(10)
                                .shadow(color: .primary.opacity(0.5), radius: 4)
                        }
                        .sheet(isPresented: $isCameraPresented) {
                            CameraView(selectedImage: $selectedImage)
                        }
                        
                        Spacer()
                        
                    }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                
                DropdownView(
                    title: "Select Language",
                    prompt: "Select",
                    options: Array(languages.keys.sorted())
                ) { selected in
                    selectedLanguage = selected
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
                
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
