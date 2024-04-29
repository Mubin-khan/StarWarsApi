//
//  SignupCD+CoreDataClass.swift
//  StarWars
//
//  Created by DSDEVMAC2 on 4/29/24.
//
//

import CoreData
import UIKit


public class SignupCD: NSManagedObject {
    class func saveSignupInfo(infos : SignUpModel) -> (Result<Bool,Error>) {
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.managedContext else {
            return .failure(CoreDataError.dataSavingError)
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "SignupCD", in: context)
        let singupData = NSManagedObject(entity: entity!, insertInto: context)
        singupData.setValue(infos.name, forKey: "name")
        singupData.setValue(infos.email, forKey: "email")
        singupData.setValue(infos.phoneNumber, forKey: "phone")
        singupData.setValue(infos.gender, forKey: "gender")
        singupData.setValue(infos.parentName, forKey: "parentName")
        
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
