//
//  PeopleModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation

// MARK: - Welcome
struct PeopleModel: Codable {
    var count: Int
    var next: String?
    var results: [PeopleResult]
}

// MARK: - Result
struct PeopleResult: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear: String
    let gender: String //Gender
    let homeworld: String
    let films, species, vehicles, starships: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}


