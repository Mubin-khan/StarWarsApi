//
//  Planet+CoreDataProperties.swift
//  StarWars
//
//  Created by Mubin Khan on 5/3/24.
//
//

import Foundation
import CoreData


extension Planet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var climate: String?
    @NSManaged public var diameter: String?
    @NSManaged public var name: String?
    @NSManaged public var peoplesInfo: PeoplesInfo?

}

extension Planet : Identifiable {

}
