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

    private init() {
        firstCreateDefaultGroup()
    }

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
    
    func loadData<T>(type: T.Type) -> [T] {
        var data = [T]()
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let result = try context.fetch(fetchRequest)
            if let objects = result as? [T] {
                data = objects
            }
            print("\(T.self) count: \(result.count)")
        } catch {
            print(error.localizedDescription)
        }
        return data
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
    
    private func firstCreateDefaultGroup() {
        
        let data = loadData(type: Group.self)
        if data.count != 0 {
            return
        }
                
        let washingTaskNames = ["Помыть пол", "Помыть окна", "Помыть ванну"]
        let creatingTaskNames = ["Приготовить ужин", "Сходить за покупками"]
        
        let groups: [(name: String, color: String, taskNames: [String])] = [
            ("Washing", "red", washingTaskNames),
            ("Creating", "yellow", creatingTaskNames)
        ]
        
        for (index, value) in groups.enumerated() {
            let group = Group(context: context)
            group.id = Int32(index)
            group.isDefault = true
            group.name = value.name
            group.color = value.color
            value.taskNames.forEach { name in
                let taskName = TaskName(context: context)
                taskName.name = name
                taskName.isDefault = true
                taskName.group = group
            }
        }
        saveContext()
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
