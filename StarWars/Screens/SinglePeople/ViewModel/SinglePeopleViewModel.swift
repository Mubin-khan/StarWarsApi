//
//  SinglePeopleViewModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/30/24.
//

import Foundation

protocol SinglePeopleViewModelProtocol : AnyObject {
    func writeDatas()
    func showError(err : DataError)
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
                let singlePeopleInfo : Result<SinglePeopleInfoModel, DataError> = try await manager.request(urlString: info.url)
               
                switch singlePeopleInfo {
                case .success(let peoleInfo) :
                    let planetInfo : Result<PeoplePlanetModel, DataError> = try await manager.request(urlString: peoleInfo.planetUrlString)
                    
                    switch planetInfo {
                    case .success(let pInfo) :
                        var speciesfInfo : [PeopleSpeciesModel] = []
                        for url in peoleInfo.speciesUrlString {
                            let tmp : Result< PeopleSpeciesModel, DataError> = try await manager.request(urlString: url)
                            switch tmp {
                            case .success(let spInfo) : speciesfInfo.append(spInfo)
                            case .failure(_) : break;
                            }
                        }
                        peopleInfo = FinalSinglePeopleInfoModel(name: info.name, gender: info.gender, dob: info.birthYear, mass: info.mass, height: info.height, skinColor: info.skinColor, panetInfo: pInfo, speciesInfo: speciesfInfo)
                        
                        delegate?.writeDatas()
                        if let peopleInfo {
                            DatabaseHelper.sharedInstance.updatePeopleInfoWithDiscription(info: peopleInfo, url: info.url)
                        }
                       
                    case .failure(let err) : delegate?.showError(err: err)
                    }
                case .failure(let err) : delegate?.showError(err: err)
                }
               
            }catch {
                print(error.localizedDescription)
            }
        }
    }
}
