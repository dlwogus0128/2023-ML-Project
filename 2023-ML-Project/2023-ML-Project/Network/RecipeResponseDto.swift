//
//  RecipeResponseDto.swift
//  2023-ML-Project
//
//  Created by 몽이 누나 on 2023/05/30.
//

import Foundation

struct RecipeResponseDto: Codable {
    let name: String
    let thumb: String
    let ingredients: [String: String]
    let steps: [Step]
}

// MARK: - Step
struct Step: Codable {
    let summury: String
}
