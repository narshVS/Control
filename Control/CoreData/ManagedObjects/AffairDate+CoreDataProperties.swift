//
//  AffairDate+CoreDataProperties.swift
//  
//
//  Created by Влад Овсюк on 04.11.2020.
//
//

import Foundation
import CoreData


extension AffairDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AffairDate> {
        return NSFetchRequest<AffairDate>(entityName: "AffairDate")
    }

    @NSManaged public var dayAffair: Date?
    @NSManaged public var affair: NSSet?

}

// MARK: Generated accessors for affair
extension AffairDate {

    @objc(addAffairObject:)
    @NSManaged public func addToAffair(_ value: Affair)

    @objc(removeAffairObject:)
    @NSManaged public func removeFromAffair(_ value: Affair)

    @objc(addAffair:)
    @NSManaged public func addToAffair(_ values: NSSet)

    @objc(removeAffair:)
    @NSManaged public func removeFromAffair(_ values: NSSet)

}
