//
//  LocalNotifications.swift
//  ServiceNotification
//
//  Created by Юрий Девятаев on 04.12.2021.
//
import UserNotifications

protocol UseNotification{
    
    var settings: UNNotificationSettings? {get}
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void)
    
    func sheduleNotification(notification: CustomNotification)
    
    func removeNotification(id: String)
    
    func removeAllPendingNotifications()
    
    func removeAllDeliveredNotifications()
}

protocol ConfigNotification{
    
    func configUserNotification()
    
}
