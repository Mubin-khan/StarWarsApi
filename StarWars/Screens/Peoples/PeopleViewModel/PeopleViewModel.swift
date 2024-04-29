//
//  PeopleViewModel.swift
//  StarWars
//
//  Created by Mubin Khan on 4/24/24.
//

import Foundation

protocol PeopleProtocol : AnyObject {
    func reloadData()
    func failedWith(error : Error)
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
                let result : PeopleModel = try await manager.request(urlString: withUrlString)
                if peoples != nil {
                    peoples?.next = result.next
                    peoples?.results.append(contentsOf: result.results)
                }else {
                    peoples = result
                }
            } catch {
                delegate?.failedWith(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchSearchedPeoples(withUrlString : String) {
        Task {
            do {
                let result : PeopleModel = try await manager.request(urlString: withUrlString)
                if searchedPeoples != nil {
                    searchedPeoples?.next = result.next
                    searchedPeoples?.results.append(contentsOf: result.results)
                }else {
                    searchedPeoples = result
                }
            } catch {
                delegate?.failedWith(error: error)
            }
        }
    }
}
