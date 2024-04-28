//
//  Peoples+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 4/27/24.
//
//

import Foundation
import CoreData


extension Peoples {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Peoples> {
        return NSFetchRequest<Peoples>(entityName: "Peoples")
    }

    @NSManaged public var total: Int64
    @NSManaged public var next: String?
    @NSManaged public var peoplesInfo: NSSet?

}

// MARK: Generated accessors for peoplesInfo
extension Peoples {

    @objc(addPeoplesInfoObject:)
    @NSManaged public func addToPeoplesInfo(_ value: PeoplesInfo)

    @objc(removePeoplesInfoObject:)
    @NSManaged public func removeFromPeoplesInfo(_ value: PeoplesInfo)

    @objc(addPeoplesInfo:)
    @NSManaged public func addToPeoplesInfo(_ values: NSSet)

    @objc(removePeoplesInfo:)
    @NSManaged public func removeFromPeoplesInfo(_ values: NSSet)

}

extension Peoples : Identifiable {

}
