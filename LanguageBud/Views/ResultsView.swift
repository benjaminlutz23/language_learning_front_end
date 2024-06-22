//
//  ResultsView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/21/24.
//

import SwiftUI

struct ResultsView: View {
    @State private var objects: [(name: String, imagePath: String)] = []
    @State private var errorMessage: String?
    let selectedImage: UIImage
    let language: String

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(objects, id: \.imagePath) { object in
                    VStack(alignment: .leading) {
                        Text(object.name)
                            .font(.headline)
                        if let url = URL(string: "http://127.0.0.1:8080/extracted/\(object.imagePath)") {
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
                    }
                    .padding()
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
