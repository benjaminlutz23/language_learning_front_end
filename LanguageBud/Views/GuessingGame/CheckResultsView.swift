//
//  CheckResultsView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/22/24.
//

import SwiftUI

struct CheckResultsView: View {
    let objects: [(name: String, imagePath: String)]
    let userGuesses: [String]
    let language: String
    @State private var results: [(word: String, guess: String, result: String)] = []
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(results, id: \.word) { result in
                    VStack(alignment: .leading) {
                        Text("Word: \(result.word)")
                        Text("Your Guess: \(result.guess)")
                        Text("Result: \(result.result)")
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check Results")
        .onAppear {
            sendGuessesToBackend { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let checkedResults):
                        self.results = checkedResults
                    case .failure(let error):
                        self.errorMessage = "Error checking translations: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

    private func sendGuessesToBackend(completion: @escaping (Result<[(word: String, guess: String, result: String)], Error>) -> Void) {
        guard let url = URL(string: "\(Config.baseURL)/check_translations") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "language": language,
            "words": objects.map { $0.name },
            "guesses": userGuesses,
            "image_paths": objects.map { $0.imagePath }
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            print("Sending JSON: \(String(data: request.httpBody!, encoding: .utf8) ?? "Invalid JSON")")
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]] {
                    print("Received JSON: \(json)")
                    let checkedResults = json.compactMap { dict -> (word: String, guess: String, result: String)? in
                        guard let word = dict["word"], let guess = dict["guess"], let result = dict["result"] else {
                            return nil
                        }
                        return (word, guess, result)
                    }
                    completion(.success(checkedResults))
                } else {
                    print("Invalid JSON received")
                    completion(.failure(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
