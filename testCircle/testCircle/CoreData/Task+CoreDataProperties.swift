//
//  Task+CoreDataProperties.swift
//  testCircle
//
//  Created by Юрий Девятаев on 09.05.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var user: User?

}

extension Task : Identifiable {

}
