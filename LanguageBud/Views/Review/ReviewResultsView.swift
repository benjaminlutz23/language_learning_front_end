//
//  ReviewResultsView.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/22/24.
//

import SwiftUI

struct ReviewResultsView: View {
    let results: [ReviewResult]

    var body: some View {
        VStack {
            List(results) { result in
                VStack(alignment: .leading) {
                    Text(result.word)
                        .font(.headline)
                    Text("Your Guess: \(result.guess)")
                        .font(.subheadline)
                    Text(result.result)
                        .font(.subheadline)
                        .foregroundColor(result.result.contains("Correct") ? .green : .red)
                }
                .padding()
            }
        }
        .navigationBarTitle("Review Results")
    }
}

struct ReviewResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewResultsView(results: [
            ReviewResult(word: "Apple", guess: "Apfel", result: "Incorrect - Correct: Manzana"),
            ReviewResult(word: "Cat", guess: "Gato", result: "Correct")
        ])
    }
}
