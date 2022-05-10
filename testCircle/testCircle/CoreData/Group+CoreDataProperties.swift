//
//  Group+CoreDataProperties.swift
//  testCircle
//
//  Created by Юрий Девятаев on 10.05.2022.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var color: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var task: NSSet?
    @NSManaged public var taskName: NSSet?
    
    public override func awakeFromInsert() {
            super.awakeFromInsert()
            isDefault = false
    }

}

// MARK: Generated accessors for task
extension Group {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

// MARK: Generated accessors for taskName
extension Group {

    @objc(addTaskNameObject:)
    @NSManaged public func addToTaskName(_ value: TaskName)

    @objc(removeTaskNameObject:)
    @NSManaged public func removeFromTaskName(_ value: TaskName)

    @objc(addTaskName:)
    @NSManaged public func addToTaskName(_ values: NSSet)

    @objc(removeTaskName:)
    @NSManaged public func removeFromTaskName(_ values: NSSet)

}

extension Group : Identifiable {

}
