//
//  DateAffairManager.swift
//  Control
//
//  Created by Влад Овсюк on 04.11.2020.
//

import Foundation
import CoreData

final class DateAffairManager {
    private var coreDataStack = CoreDataStack()
    
    func fetchAffairDate(completion: @escaping ([DateAffair]) -> Void) {
        let affairDateFetch: NSFetchRequest<DateAffair> = DateAffair.fetchRequest()
        do {
            let affairDates = try coreDataStack.managedContext.fetch(affairDateFetch)
            completion(affairDates)
        } catch let error as NSError {
            print("Fetch error: \(error). Description: \(error.userInfo)")
            completion([])
        }
    }
    
    func addAffairDate(day: Int, month: Int, year: Int) {
        let dateAffair = DateAffair(context: coreDataStack.managedContext)
        dateAffair.day = Int16(day)
        dateAffair.month = Int16(month)
        dateAffair.year = Int16(year)
        coreDataStack.saveContext()
    }
}
