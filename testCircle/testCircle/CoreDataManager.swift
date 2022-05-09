//
//  CoreDataManager.swift
//  testCircle
//
//  Created by Юрий Девятаев on 09.05.2022.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let instanse = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {}

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "testCircle")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                debugPrint("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func remove(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func saveContext () {
        if !context.hasChanges {
            return
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func loadContext() -> [User] {
        var array = [User]()
        do {
            let result = try context.fetch(User.fetchRequest())
            array = result
        } catch {
            print(error.localizedDescription)
        }
        return array.sorted{$0.id < $1.id}
    }
    
    func getUser(id: Int) -> User? {
        let request = User.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let result = try? context.fetch(request)
        if result?.count == 1 {
            return result?[0]
        }
        return nil
    }
    
//    func loadData<T>() -> [T] {
//        var data = [T]()
//        let entityName = String(describing: T.self)
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        do {
//            let result = try context.fetch(fetchRequest)
//            if let objects = result as? [T] {
//                data = objects
//            }
//            print("\(T.self) count: \(result.count)")
//        } catch {
//            print(error.localizedDescription)
//        }
//        return data
//    }
}
