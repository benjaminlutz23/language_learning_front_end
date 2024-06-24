//
//  MissedWord.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/22/24.
//

import Foundation

struct MissedWord: Identifiable, Decodable {
    let id: Int64
    let correctGuesses: Int
    let englishWord: String
    let imagePath: String
    let language: String
    let timestamp: String
    let translation: String

    enum CodingKeys: String, CodingKey {
        case id
        case correctGuesses = "correct_guesses"
        case englishWord = "english_word"
        case imagePath = "image_path"
        case language
        case timestamp
        case translation
    }
}
