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

class SinglePeopleViewModel {
    private let manager = APIManager()
    weak var delegate : SinglePeopleViewModelProtocol?
    
    var peopleInfo : FinalSinglePeopleInfoModel? {
        didSet {
            delegate?.writeDatas()
        }
    }
    
    func fetchPeopleInfo(with urlStirng : String){
        Task {
            do {
                let singlePeopleInfo : SinglePeopleInfoModel = try await manager.request(urlString: urlStirng)
                
                let planetInfo : PeoplePlanetModel? = try await manager.request(urlString: singlePeopleInfo.planetUrlString ?? "")
                var speciesfInfo : [PeopleSpeciesModel] = []
                for url in singlePeopleInfo.speciesUrlString {
                    let tmp : PeopleSpeciesModel = try await manager.request(urlString: url)
                    speciesfInfo.append(tmp)
                }
                
                peopleInfo = FinalSinglePeopleInfoModel(name: singlePeopleInfo.name, gender: singlePeopleInfo.gender, dob: singlePeopleInfo.dob, mass: singlePeopleInfo.mass, height: singlePeopleInfo.height, skinColor: singlePeopleInfo.skinColor, panetInfo: planetInfo, speciesInfo: speciesfInfo)
            }catch {
                
            }
        }
    }
}
