//
//  AffairDateManager.swift
//  Control
//
//  Created by Влад Овсюк on 04.11.2020.
//

import Foundation
import CoreData

final class AffairDateManager {
    private var coreDataStack = CoreDataStack()
    
    func fetchGroups(completion: @escaping ([AffairDate]) -> Void) {
        let affairDateFetch: NSFetchRequest<AffairDate> = AffairDate.fetchRequest()
        do {
            let affairDates = try coreDataStack.managedContext.fetch(affairDateFetch)
            completion(affairDates)
        } catch let error as NSError {
            print("Fetch error: \(error). Description: \(error.userInfo)")
            completion([])
        }
    }
    
    func addGroup(date: Date) {
        let affairDate = AffairDate(context: coreDataStack.managedContext)
        affairDate.dayAffair = date
        coreDataStack.saveContext()
    }
}
