//
//  SinglePeopleViewModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/30/24.
//

import Foundation

protocol SinglePeopleViewModelProtocol : AnyObject {
    func writeDatas()
}

@MainActor
class SinglePeopleViewModel {
    private let manager = APIManager()
    weak var delegate : SinglePeopleViewModelProtocol?
    
    var peopleInfo : FinalSinglePeopleInfoModel? {
        didSet {
            delegate?.writeDatas()
        }
    }
    
    func fetchPeopleInfo(with info : PeopleResult){
        Task {
            do {
                let singlePeopleInfo : SinglePeopleInfoModel = try await manager.request(urlString: info.url)
                
                let planetInfo : PeoplePlanetModel? = try await manager.request(urlString: singlePeopleInfo.planetUrlString)
                var speciesfInfo : [PeopleSpeciesModel] = []
                for url in singlePeopleInfo.speciesUrlString {
                    let tmp : PeopleSpeciesModel = try await manager.request(urlString: url)
                    speciesfInfo.append(tmp)
                }
                
                peopleInfo = FinalSinglePeopleInfoModel(name: info.name, gender: info.gender, dob: info.birthYear, mass: info.mass, height: info.height, skinColor: info.skinColor, panetInfo: planetInfo, speciesInfo: speciesfInfo)
                
                delegate?.writeDatas()
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
