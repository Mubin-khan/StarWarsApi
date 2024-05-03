//
//  PeoplesInfo+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 5/3/24.
//
//

import Foundation
import CoreData


extension PeoplesInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeoplesInfo> {
        return NSFetchRequest<PeoplesInfo>(entityName: "PeoplesInfo")
    }

    @NSManaged public var birthYear: String?
    @NSManaged public var gender: String?
    @NSManaged public var height: String?
    @NSManaged public var mass: String?
    @NSManaged public var name: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var url: String?
    @NSManaged public var peoples: Peoples?
    @NSManaged public var species: NSSet?
    @NSManaged public var planet: Planet?

}

// MARK: Generated accessors for species
extension PeoplesInfo {

    @objc(addSpeciesObject:)
    @NSManaged public func addToSpecies(_ value: Species)

    @objc(removeSpeciesObject:)
    @NSManaged public func removeFromSpecies(_ value: Species)

    @objc(addSpecies:)
    @NSManaged public func addToSpecies(_ values: NSSet)

    @objc(removeSpecies:)
    @NSManaged public func removeFromSpecies(_ values: NSSet)

}

extension PeoplesInfo : Identifiable {

}
