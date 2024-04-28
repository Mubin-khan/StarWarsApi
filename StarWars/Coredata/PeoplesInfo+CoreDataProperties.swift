//
//  PeoplesInfo+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 4/27/24.
//
//

import Foundation
import CoreData


extension PeoplesInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeoplesInfo> {
        return NSFetchRequest<PeoplesInfo>(entityName: "PeoplesInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var birthYear: String?
    @NSManaged public var url: String?
    @NSManaged public var peoples: Peoples?

}

extension PeoplesInfo : Identifiable {

}
