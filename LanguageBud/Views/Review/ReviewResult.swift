//
//  ReviewResult.swift
//  LanguageBud
//
//  Created by Benjamin Lutz on 6/22/24.
//

import Foundation

struct ReviewResult: Codable, Identifiable {
    var id: String { word }
    var word: String
    var guess: String
    var result: String
}

