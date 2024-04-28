//
//  DatabaseHelper.swift
//  StarWars
//
//  Created by Mubin Khan on 4/27/24.
//

import UIKit
import CoreData

class DatabaseHelper {
    static var sharedInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.managedContext
    
    func savePeoplesInfo(results : PeopleModel){
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
            peoplesInformations.append(info)
        }
        let infoSet = NSSet.init(array: peoplesInformations)
        project.peoplesInfo = infoSet
        
        do {
            try context.save()
        }catch {
            print("data is not saved")
        }
    }
    
    func getPeoplesInfo() -> PeopleModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Peoples")
        let peoplesInfo : Peoples?
        do {
            peoplesInfo = try context?.fetch(fetchRequest) as? Peoples
            
            if let peoplesInfo {
                
                var result : [PeopleResult] = []
                if let temp = peoplesInfo.peoplesInfo {
                    for inf in temp {
                        if let currentInfo = inf as? PeoplesInfo {
                            let cur = PeopleResult(name: currentInfo.name!, gender: currentInfo.gender!, birthYear: currentInfo.birthYear!, url: currentInfo.url!)
                            result.append(cur)
                        }
                        
                    }
                }
               
                let finalResult : PeopleModel? = PeopleModel (
                    count: Int(peoplesInfo.total),
                    next : peoplesInfo.next,
                    results: result
                )
                
                return finalResult
            }
        }catch {
            print("couldn't find data")
        }
        
        return nil
    }
}
