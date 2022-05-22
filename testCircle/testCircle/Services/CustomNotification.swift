//
//  Task.swift
//  ServiceNotification
//
//  Created by Юрий Девятаев on 04.12.2021.
//

import Foundation

struct CustomNotification: Codable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String?
    var body: String?
    var threadIdentifier: String?
    var complete: Bool
    var reminderEnabled: Bool
    var reminder: Reminder
}

struct Reminder: Codable{
    var timeInterval: Double?
    var date: Date?
    var location: LocationReminder?
    var type: RemainderType
    var repeats: Bool
}

enum RemainderType: Int, Codable{
    case time
    case calendar
    case location
}

struct LocationReminder: Codable{
    var latitude: Double
    var longitude: Double
    var radius: Double
}
