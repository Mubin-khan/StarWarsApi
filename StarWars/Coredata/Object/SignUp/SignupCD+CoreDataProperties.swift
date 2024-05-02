//
//  SignupCD+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 5/2/24.
//
//

import Foundation
import CoreData


extension SignupCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SignupCD> {
        return NSFetchRequest<SignupCD>(entityName: "SignupCD")
    }

    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var name: String?
    @NSManaged public var parentName: String?
    @NSManaged public var phone: String?
    @NSManaged public var password: String?

}

extension SignupCD : Identifiable {

}
