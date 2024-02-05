//
//  LocalNotificationManager.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 05/02/2024.
//

import Foundation
import UserNotifications

struct Notification {
    var id: String
    var title: String
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission(time: TimeInterval) -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications(time: time)
                    // We have permission!
                }
            }
    }
    
    func addNotification(title: String) -> Void {
        notifications.append(Notification(id: UUID().uuidString, title: title))
    }
    
    func scheduleNotifications(time: TimeInterval) -> Void {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notification.id)")
            }
        }
    }
    
    func schedule(time: TimeInterval = 5) -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission(time: time)
            case .authorized, .provisional:
                self.scheduleNotifications(time: time)
            default:
                break
            }
        }
    }
}
