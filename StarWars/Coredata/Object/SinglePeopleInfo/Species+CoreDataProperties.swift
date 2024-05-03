//
//  Species+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 5/3/24.
//
//

import Foundation
import CoreData


extension Species {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Species> {
        return NSFetchRequest<Species>(entityName: "Species")
    }

    @NSManaged public var classification: String?
    @NSManaged public var designation: String?
    @NSManaged public var name: String?
    @NSManaged public var peoplesInfo: PeoplesInfo?

}

extension Species : Identifiable {

}
