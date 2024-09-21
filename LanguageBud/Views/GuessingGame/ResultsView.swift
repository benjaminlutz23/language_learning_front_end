//
//  ResultsView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/21/24.
//

import SwiftUI

struct ResultsView: View {
    @State private var objects: [(name: String, imagePath: String)] = []
    @State private var userGuesses: [String] = []
    @State private var errorMessage: String?
    @State private var isCheckingGuesses = false
    let selectedImage: UIImage
    let language: String

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(objects.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            if let url = URL(string: "\(Config.baseURL)/extracted/\(objects[index].imagePath)") {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 200)
                                    case .failure:
                                        Image(systemName: "xmark.circle")
                                    @unknown default:
                                        Image(systemName: "xmark.circle")
                                    }
                                }
                            }
                            Text(objects[index].name)
                                .font(.headline)
                        }
                        .padding()

                        TextField("Enter \(language) translation", text: Binding(
                            get: {
                                userGuesses.count > index ? userGuesses[index] : ""
                            },
                            set: { newValue in
                                if userGuesses.count > index {
                                    userGuesses[index] = newValue
                                } else {
                                    userGuesses.append(newValue)
                                }
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    }
                }

                Button(action: {
                    isCheckingGuesses = true
                }) {
                    Text("Check Translations")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isCheckingGuesses) {
                    CheckResultsView(objects: objects, userGuesses: userGuesses, language: language)
                }
            }
        }
        .navigationBarTitle("Results")
        .onAppear {
            uploadImage(image: selectedImage) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let objects):
                        self.objects = objects
                        self.userGuesses = Array(repeating: "", count: objects.count)
                    case .failure(let error):
                        self.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(selectedImage: UIImage(named: "example")!, language: "EN")
    }
}
