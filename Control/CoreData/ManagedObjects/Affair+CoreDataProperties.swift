//
//  Affair+CoreDataProperties.swift
//  
//
//  Created by Влад Овсюк on 05.11.2020.
//
//

import Foundation
import CoreData


extension Affair {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Affair> {
        return NSFetchRequest<Affair>(entityName: "Affair")
    }

    @NSManaged public var dateAffair: Date?
    @NSManaged public var descript: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?

}
