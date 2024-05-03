//
//  DatabaseHelper.swift
//  StarWars
//
//  Created by Mubin Khan on 4/27/24.
//

import UIKit
import CoreData

enum CoreDataError : Error {
    case dataSavingError
}

class DatabaseHelper {
    static var sharedInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.managedContext
    
    func updatePeopleInfoWithDiscription(info : FinalSinglePeopleInfoModel, url : String) {
        guard let context = context else {return}
        
        var project : [Peoples]
        let fetchRequest = NSFetchRequest<Peoples>(entityName: "Peoples")
        
        do {
            project = try context.fetch(fetchRequest)
            
            if let peoplesInfo = project.first?.peoplesInfo as? Set<PeoplesInfo> {
                for information in peoplesInfo {
                    if information.url == url {
                        let planetProject = NSEntityDescription.insertNewObject(forEntityName: "Planet", into: context) as! Planet
                        planetProject.name = info.panetInfo?.name
                        planetProject.climate = info.panetInfo?.climate
                        planetProject.diameter = info.panetInfo?.diameter
                        
                        
                        var species = [Species]()
                        for tmp in info.speciesInfo {
                            let speciesProject = NSEntityDescription.insertNewObject(forEntityName: "Species", into: context) as! Species
                            speciesProject.name = tmp.name
                            speciesProject.classification = tmp.classification
                            speciesProject.designation = tmp.designation
                            
                            species.append(speciesProject)
                        }
                        
                        let speciesSet = NSSet.init(array: species)
                        information.species = speciesSet
                        information.planet = planetProject
                        break
                    }
                    
                }
               
                do {
                    try context.save()
                }catch {
                    print("data is not saved")
                }
            }
          
        }catch {
            print("couldn't find data")
        }
        
       
    }
    
    func savePeoplesInfo(results : PeopleModel, disc : [String : FinalSinglePeopleInfoModel]){
        guard let context = context else {return}
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Peoples")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PeoplesInfo")
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try context.execute(deleteRequest)
            try context.execute(deleteRequest1)
        } catch {
            
        }
        
        let project = NSEntityDescription.insertNewObject(forEntityName: "Peoples", into: context) as! Peoples
        
        project.total = Int64(results.count ?? 0)
        project.next = results.next
        
        var peoplesInformations = [PeoplesInfo]()
        for information in results.results {
            let info = NSEntityDescription.insertNewObject(forEntityName: "PeoplesInfo", into: context) as! PeoplesInfo
            info.name = information.name
            info.gender = information.gender
            info.birthYear = information.birthYear
            info.url = information.url
            info.height = information.height
            info.mass = information.mass
            info.skinColor = information.skinColor
            peoplesInformations.append(info)
            
            if let url = info.url {
                let discription = disc[url]
                let planetCD = NSEntityDescription.insertNewObject(forEntityName: "Planet", into: context) as! Planet
                planetCD.name = discription?.panetInfo?.name
                planetCD.diameter = discription?.panetInfo?.diameter
                planetCD.climate = discription?.panetInfo?.climate
                
                info.planet = planetCD
                if let spcDis = discription?.speciesInfo {
                    var spcArray = [Species]()
                    for spc in spcDis {
                        let speciesCD = NSEntityDescription.insertNewObject(forEntityName: "Species", into: context) as! Species
                        speciesCD.name = spc.name
                        speciesCD.designation = spc.designation
                        speciesCD.classification = spc.classification
                        spcArray.append(speciesCD)
                    }
                    info.species = NSSet.init(array: spcArray)
                }
            }
        }
        let infoSet = NSSet.init(array: peoplesInformations)
        project.peoplesInfo = infoSet
        
        do {
            try context.save()
        }catch {
            print("data is not saved")
        }
    }
    
    func getPeoplesInfo() -> (PeopleModel?, [String : FinalSinglePeopleInfoModel]) {
        guard let context = context else {return (nil, [:])}
        
        var peoplesInfo = [Peoples]()
        var singleInfos : [String : FinalSinglePeopleInfoModel] = [:]
        do {
            let fetchRequest = NSFetchRequest<Peoples>(entityName: "Peoples")
            fetchRequest.fetchLimit = 1
            peoplesInfo = try context.fetch(fetchRequest)
            
            for people in peoplesInfo {
                    var result : [PeopleResult] = []
                    if let temp = people.peoplesInfo {
                        for inf in temp {
                            if let currentInfo = inf as? PeoplesInfo {
                                let cur = PeopleResult(name: currentInfo.name ?? "", gender: currentInfo.gender ?? "", birthYear: currentInfo.birthYear ?? "", url: currentInfo.url ?? "", mass: currentInfo.mass ?? "", height: currentInfo.height ?? "", skinColor: currentInfo.skinColor ?? "")
                                result.append(cur)
                                
                                let planet = currentInfo.planet
                                var species = [PeopleSpeciesModel]()
                                if let sp = currentInfo.species {
                                    for sps in sp {
                                        if let tmp = sps as? Species {
                                            let spInfo = PeopleSpeciesModel(name: tmp.name ?? "", classification: tmp.classification ?? "", designation: tmp.designation ?? "")
                                            species.append(spInfo)
                                        }
                                    }
                                }
                                
                               let curPlanet = PeoplePlanetModel(name: planet?.name ?? "", diameter: planet?.diameter ?? "", climate: planet?.climate ?? "")
                                let copy = FinalSinglePeopleInfoModel(name: currentInfo.name ?? "", gender: currentInfo.gender ?? "", dob: currentInfo.birthYear ?? "", mass: currentInfo.mass ?? "", height: currentInfo.height ?? "", skinColor: currentInfo.skinColor ?? "", panetInfo : curPlanet, speciesInfo: species)
                                let url = cur.url
                                singleInfos[url] = copy
                            }
                            
                        }
                    }
                   
                    let finalResult : PeopleModel? = PeopleModel (
                        count: Int(people.total),
                        next : people.next,
                        results: result
                    )
                    
                    return (finalResult, singleInfos)
            }
        }catch {
            print("couldn't find data")
        }
        
        return (nil, singleInfos)
    }
}
