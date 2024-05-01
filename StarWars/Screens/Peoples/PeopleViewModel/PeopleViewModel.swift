//
//  PeopleViewModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation

protocol PeopleProtocol : AnyObject {
    func reloadData()
    func failedWith(error : DataError)
    func failedSearch(errr : DataError)
}

@MainActor
class PeopleViewModel {
    private let manager = APIManager()
    weak var delegate : PeopleProtocol?
    
    var peoples : PeopleModel? = nil {
        didSet {
            delegate?.reloadData()
            if let peoples {
                DatabaseHelper.sharedInstance.savePeoplesInfo(results: peoples)
            }
        }
    }
    
    var searchedPeoples : PeopleModel? = nil {
        didSet {
            delegate?.reloadData()
        }
    }
    
    func fetchPeoples(withUrlString : String) {
        Task {
            do {
                let result : Result< PeopleModel, DataError> = try await manager.request(urlString: withUrlString)
                switch result {
                case .success(let p) :
                    if peoples != nil {
                        peoples?.next = p.next
                        peoples?.results.append(contentsOf: p.results)
                    }else {
                        peoples = p
                    }
                case .failure(let er) :
                    delegate?.failedWith(error: er)
                }
               
            } catch {
                delegate?.failedWith(error: DataError.unknownError)
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchSearchedPeoples(withUrlString : String) {
        Task {
            do {
                let result : Result< PeopleModel, DataError> = try await manager.request(urlString: withUrlString)
                switch result {
                case .success(let res) :
                    if searchedPeoples != nil {
                        searchedPeoples?.next = res.next
                        searchedPeoples?.results.append(contentsOf: res.results)
                    }else {
                        searchedPeoples = res
                    }
                case .failure(let err) : delegate?.failedSearch(errr: err)
                    
                }
            } catch {
                delegate?.failedSearch(errr: DataError.unknownError)
            }
        }
    }
}
