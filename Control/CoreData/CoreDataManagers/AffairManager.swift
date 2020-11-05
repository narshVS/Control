//
//  AffairsManager.swift
//  Control
//
//  Created by Влад Овсюк on 04.11.2020.
//

import Foundation
import CoreData

final class AffairManager {
    private var coreDataStack = CoreDataStack()

    func fetchAffairs(from affairDate: DateAffair?, completion: @escaping ([Affair]) -> Void) {
        guard let dateAffair = affairDate else {
            completion([])
            return
        }
        let affairsFetch: NSFetchRequest<Affair> = Affair.fetchRequest()
        affairsFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Affair.dateForAffair), dateAffair)
        do {
            let affairDates = try coreDataStack.managedContext.fetch(affairsFetch)
            completion(affairDates)
        } catch let error as NSError {
            print("Fetch error: \(error). Description: \(error.userInfo)")
            completion([])
        }
    }

    func addAffair(title: String, descript: String, isDone : Bool, dayAffair: Date, to date: DateAffair) {
        let affair = Affair(context: coreDataStack.managedContext)
        affair.title = title
        affair.descript = descript
        affair.isDone = isDone
        affair.dayAffair = dayAffair
        affair.dateForAffair = date
        coreDataStack.saveContext()
    }

    func deleteAffair(object: NSManagedObject) {
        coreDataStack.deleteContext(object: object)
        coreDataStack.saveContext()
    }
}
