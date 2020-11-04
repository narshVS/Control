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

    func fetchAffairs(from affairDate: AffairDate?, completion: @escaping ([Affair]) -> Void) {
        guard let affairDate = affairDate else {
            completion([])
            return
        }
        let affairsFetch: NSFetchRequest<Affair> = Affair.fetchRequest()
        affairsFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Affair.affaitDate), affairDate)
        do {
            let affairDates = try coreDataStack.managedContext.fetch(affairsFetch)
            completion(affairDates)
        } catch let error as NSError {
            print("Fetch error: \(error). Description: \(error.userInfo)")
            completion([])
        }
    }

    func addNote(title: String, descript: String, isDone : Bool, dayAffair: Date, to date: AffairDate) {
        let affair = Affair(context: coreDataStack.managedContext)
        affair.title = title
        affair.descript = descript
        affair.isDone = isDone
        affair.dayAffair = dayAffair
        affair.affaitDate = date
        coreDataStack.saveContext()
    }

    func deleteNote(object: NSManagedObject) {
        coreDataStack.deleteContext(object: object)
        coreDataStack.saveContext()
    }
}
