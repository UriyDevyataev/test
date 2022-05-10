//
//  Task+CoreDataProperties.swift
//  testCircle
//
//  Created by Юрий Девятаев on 10.05.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var user: User?
    @NSManaged public var group: Group?

}

extension Task : Identifiable {

}
