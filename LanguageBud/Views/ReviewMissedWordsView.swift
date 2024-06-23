//
//  ReviewMissedWordsView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/22/24.
//

import SwiftUI

struct ReviewMissedWordsView: View {
    @State private var missedWords: [MissedWord] = []
    @State private var errorMessage: String?
    let language: String

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(missedWords) { missedWord in
                    VStack(alignment: .leading) {
                        Text("Word: \(missedWord.englishWord)")
                            .font(.headline)
                        Text("Guesses: \(missedWord.correctGuesses)")
                            .font(.subheadline)
                        Text("Translation: \(missedWord.translation)")
                            .font(.subheadline)
                        Text("Timestamp: \(missedWord.timestamp)")
                            .font(.subheadline)
                        Text("Image Path: \(missedWord.imagePath)")
                            .font(.subheadline)
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Review Missed Words")
        .onAppear {
            fetchMissedWords()
        }
    }

    private func fetchMissedWords() {
        guard let url = URL(string: "http://127.0.0.1:8080/review_missed_words") else {
            self.errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["language": language]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch missed words: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                }
                return
            }

            do {
                let jsonString = String(data: data, encoding: .utf8)
                print("Received JSON: \(jsonString ?? "No JSON")")
                
                let decodedWords = try JSONDecoder().decode([MissedWord].self, from: data)
                DispatchQueue.main.async {
                    self.missedWords = decodedWords
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode missed words: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct ReviewMissedWordsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewMissedWordsView(language: "EN")
    }
}
