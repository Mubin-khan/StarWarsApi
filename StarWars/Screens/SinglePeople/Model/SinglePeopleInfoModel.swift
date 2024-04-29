//
//  SinglePeopleInfoModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/30/24.
//

import Foundation

struct SinglePeopleInfoModel : Codable {
    var name : String
    var gender : String
    var dob : String
    var mass : String
    var height : String
    var skinColor : String
    var planetUrlString : String?
    var speciesUrlString : [String]
    
    enum Codingkeys : String, CodingKey {
        case name, gender, height, mass
        case planetUrlString = "homeworld"
        case speciesUrlString = "species"
    }
}


struct FinalSinglePeopleInfoModel {
    var name : String
    var gender : String
    var dob : String
    var mass : String
    var height : String
    var skinColor : String
    var panetInfo : PeoplePlanetModel?
    var speciesInfo : [PeopleSpeciesModel]
}

