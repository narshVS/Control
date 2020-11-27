//
//  AffairsManager.swift
//  Control
//
//  Created by Влад Овсюк on 04.11.2020.
//

import Foundation
import CoreData

final class AffairManager {
    
    static var manager: AffairManager = {
        return AffairManager()
    }()
    
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
        coreDataStack.managedContext.delete(object)
        coreDataStack.saveContext()
    }
    
    func exchangeAffair(object: NSManagedObject, title: String, descript: String, isDone : Bool, dayAffair: Date) {
        object.setValue(title, forKey: "title")
        object.setValue(descript, forKey: "descript")
        object.setValue(isDone, forKey: "isDone")
        object.setValue(dayAffair, forKey: "dateAffair")
        coreDataStack.saveContext()
    }
    
    func clearData() {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: "Affair")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try coreDataStack.managedContext.execute(DelAllReqVar) }
        catch { print(error) }
    }
}
