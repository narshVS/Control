//
//  DateAffair+CoreDataProperties.swift
//  
//
//  Created by Влад Овсюк on 05.11.2020.
//
//

import Foundation
import CoreData


extension DateAffair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DateAffair> {
        return NSFetchRequest<DateAffair>(entityName: "DateAffair")
    }

    @NSManaged public var day: Int16
    @NSManaged public var month: Int16
    @NSManaged public var year: Int16
    @NSManaged public var affair: NSSet?

}

// MARK: Generated accessors for affair
extension DateAffair {

    @objc(addAffairObject:)
    @NSManaged public func addToAffair(_ value: Affair)

    @objc(removeAffairObject:)
    @NSManaged public func removeFromAffair(_ value: Affair)

    @objc(addAffair:)
    @NSManaged public func addToAffair(_ values: NSSet)

    @objc(removeAffair:)
    @NSManaged public func removeFromAffair(_ values: NSSet)

}
