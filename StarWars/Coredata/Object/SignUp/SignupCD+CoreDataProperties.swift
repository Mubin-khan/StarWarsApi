//
//  SignupCD+CoreDataProperties.swift
//  StarWars
//
//  Created by DSDEVMAC2 on 4/29/24.
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

}

extension SignupCD : Identifiable {

}
