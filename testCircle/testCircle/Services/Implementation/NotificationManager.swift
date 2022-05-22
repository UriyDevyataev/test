//
//  LocalNotification.swift
//  ServiceNotification
//
//  Created by Юрий Девятаев on 04.12.2021.
//

import UIKit

class NotificationManager: ConfigNotification, UseNotification{
    
//    static let shared = NotificationManager()
    
    let unCenter = UNUserNotificationCenter.current()
    var settings: UNNotificationSettings?
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        unCenter.requestAuthorization(
            options: [.alert, .sound, .badge]) { granted, _ in
                self.fetchNotificationSettings()
                completion(granted)
            }
    }
    
    private func createContent(notification: CustomNotification) -> UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        
        content.title = notification.title
        if let subtitle = notification.subTitle {
            content.subtitle = subtitle
        }
        
        if let body = notification.body {
            content.body = body
        }
        
        content.categoryIdentifier = "myCategory"
        let notificationData = try? JSONEncoder().encode(notification)
        if let notificationData = notificationData {
            content.userInfo = ["notification": notificationData]
        }
        return content
    }
    
    private func createTrigger(notification: CustomNotification) -> UNNotificationTrigger?{
        
        var trigger: UNNotificationTrigger?
        
        switch notification.reminder.type{
        case .time:
            guard let timeInterval = notification.reminder.timeInterval else {return nil}
            trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: timeInterval,
                repeats: notification.reminder.repeats)
            
        case .calendar:
            guard let date = notification.reminder.date else {return nil}
            let dateComponents = Calendar.current.dateComponents(
                [.day, .month, .year, .hour, .minute],
                from: date)
            trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: notification.reminder.repeats)
            
        case .location: break
        }
        return trigger
    }
        
    func sheduleNotification(notification: CustomNotification) {
        
        let content = createContent(notification: notification)
        let trigger = createTrigger(notification: notification)
        
        guard let trigger = trigger else {return}
        let request = UNNotificationRequest(
            identifier: notification.id,
            content: content,
            trigger: trigger)
        
        unCenter.add(request) { error in
            guard let error = error else {return}
            print(error)
        }
    }
    
    func removeNotification(id: String) {
        unCenter.removePendingNotificationRequests(
            withIdentifiers:[id]
        )
    }
    
    func removeAllPendingNotifications(){
        unCenter.removeAllPendingNotificationRequests()
    }
    
    func removeAllDeliveredNotifications(){
        unCenter.removeAllDeliveredNotifications()
    }
    
    func fetchNotificationSettings(){
        unCenter.getNotificationSettings {settings in
            DispatchQueue.main.async { [weak self] in
                self?.settings = settings
            }
        }
    }
    
    func configUserNotification(){
        
        unCenter.delegate = UIApplication.shared.delegate as? AppDelegate

        let dismissAction = UNNotificationAction(
            identifier: "dismiss",
            title: "Dismiss",
            options: [.destructive])

        let doSmthAction = UNNotificationAction(
            identifier: "doSmth",
            title: "Do Smth",
            options: [])

        let goToAppAction = UNNotificationAction(
            identifier: "goToApp",
            title: "Go to App",
            options: [.foreground])

        let category = UNNotificationCategory(
            identifier: "myCategory",
            actions: [dismissAction, doSmthAction, goToAppAction],
            intentIdentifiers: [],
            options: [])

        unCenter.setNotificationCategories([category])
    }
}
