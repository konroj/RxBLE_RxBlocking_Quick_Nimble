//
//  CoreDataManager.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BloodPressure")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
    
extension CoreDataManager {
    
    func loadBloodPressureEntities() -> [BloodPressure] {
        let request = NSFetchRequest<BloodPressureEntity>(entityName: NSStringFromClass(BloodPressureEntity.self))
        request.returnsObjectsAsFaults = false
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result.map({ BloodPressure(model: $0) })
        } catch {
            fatalError("Error while retriving \(NSStringFromClass(BloodPressureEntity.self)) items")
        }
    }
    
    func saveBloodPressure(_ model: BloodPressure) {
        let context = persistentContainer.viewContext
        let entity = BloodPressureEntity(context: context)
        entity.date = model.date
        entity.value = model.value
        saveContext()
    }
    
    func clearAll() {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: NSStringFromClass(BloodPressureEntity.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
           fatalError("Error while removing \(NSStringFromClass(BloodPressureEntity.self)) items")
        }
    }
    
}

extension CoreDataManager {
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
