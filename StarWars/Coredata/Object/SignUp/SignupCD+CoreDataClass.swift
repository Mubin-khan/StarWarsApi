//
//  SignupCD+CoreDataClass.swift
//  StarWars
//
//  Created by Mubin Khan on 5/2/24.
//
//

import UIKit
import CoreData


public class SignupCD: NSManagedObject {
    class func saveSignupInfo(infos : SignUpModel) -> (Result<Bool,Error>) {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.managedContext else {
            return .failure(CoreDataError.dataSavingError)
        }
        
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SignupCD")
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        
        do {
            try context.execute(deleteRequest1)
        } catch {
            
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "SignupCD", in: context)
        let singupData = NSManagedObject(entity: entity!, insertInto: context)
        singupData.setValue(infos.name, forKey: "name")
        singupData.setValue(infos.email, forKey: "email")
        singupData.setValue(infos.phoneNumber, forKey: "phone")
        singupData.setValue(infos.gender, forKey: "gender")
        singupData.setValue(infos.parentName, forKey: "parentName")
        singupData.setValue(infos.password, forKey: "password")
        
        do {
            try context.save()
        } catch {
            return .failure(CoreDataError.dataSavingError)
        }
        
        return .success(true)
    }
    
    class func getLoginMail() -> String {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.managedContext else {
            return ""
        }
        
        let fetchRequest = NSFetchRequest<SignupCD>(entityName: "SignupCD")
        fetchRequest.fetchLimit = 1
        do {
            let signUpDats = try context.fetch(fetchRequest)
            for info in signUpDats {
                let email = info.email
                return email ?? ""
            }
        } catch {
            return ""
        }
        return ""
    }
}
