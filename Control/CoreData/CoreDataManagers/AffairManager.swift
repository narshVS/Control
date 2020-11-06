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

    func fetchAffairs(completion: @escaping ([Affair]) -> Void) {
        let affairFetch: NSFetchRequest<Affair> = Affair.fetchRequest()
        do {
            let affairs = try coreDataStack.managedContext.fetch(affairFetch)
            completion(affairs)
        } catch let error as NSError {
            print("Fetch error: \(error). Description: \(error.userInfo)")
            completion([])
        }
    }

    func addAffair(title: String, descript: String, isDone : Bool, dayAffair: Date) {
        let affair = Affair(context: coreDataStack.managedContext)
        affair.title = title
        affair.descript = descript
        affair.isDone = isDone
        affair.dateAffair = dayAffair
        coreDataStack.saveContext()
    }

    func deleteAffair(object: NSManagedObject) {
        coreDataStack.deleteContext(object: object)
        coreDataStack.saveContext()
    }
}
