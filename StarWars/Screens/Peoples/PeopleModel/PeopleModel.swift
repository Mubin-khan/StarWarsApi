//
//  PeopleModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation

// MARK: - Welcome
struct PeopleModel: Codable {
    var count: Int?
    var next: String?
    var results: [PeopleResult]
}

struct PeopleResult : Codable {
    let name, gender : String
    let birthYear : String
    let url : String
    var mass : String
    var height : String
    var skinColor : String
    
    enum CodingKeys : String, CodingKey {
        case name, gender, url, mass, height
        case birthYear = "birth_year"
        case skinColor = "skin_color"
    }
}

//struct PeopleModelToShow {
//    var count: Int?
//    var next: String?
//    var results: [PeopleResultToShow]
//}
//
//
//struct PeopleResultToShow {
//    let name, gender : String
//    let birthYear : String
//    let url : String
//    var mass : String
//    var height : String
//    var skinColor : String
//    var planet : PeoplePlanetModel
//    var species : [PeopleSpeciesModel]
// 
//}



