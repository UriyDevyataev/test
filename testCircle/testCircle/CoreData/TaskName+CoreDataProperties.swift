//
//  TaskName+CoreDataProperties.swift
//  testCircle
//
//  Created by Юрий Девятаев on 10.05.2022.
//
//

import Foundation
import CoreData


extension TaskName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskName> {
        return NSFetchRequest<TaskName>(entityName: "TaskName")
    }

    @NSManaged public var name: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var group: Group?
    
    public override func awakeFromInsert() {
            super.awakeFromInsert()
            isDefault = false
    }

}

extension TaskName : Identifiable {

}
