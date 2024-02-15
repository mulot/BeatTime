//
//  LocalNotificationManager.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 05/02/2024.
//

import Foundation
import UserNotifications

struct Notification: Identifiable, Hashable {
    var id: String
    var title: String
    var timer: TimeInterval
    var date: Date
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission(notif: Notification) -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications(notif: notif)
                    // We have permission!
                }
            }
    }
    
    func addNotification(title: String, time: TimeInterval, date: Date) -> Void {
        let notif = Notification(id: UUID().uuidString, title: title, timer: time, date: date)
        notifications.append(notif)
        self.schedule(notif: notif)
    }
    
    func removeNotification(notif: Notification) -> Void {
        if let index = notifications.firstIndex(of: notif) {
            //print("remove notif: \(notif.id)")
            notifications.remove(at: index)
            self.unscheduleNotifications(notif: notif)
        }
    }
    
    func scheduleNotifications(notif: Notification) -> Void {
            let content = UNMutableNotificationContent()
            content.title = notif.title
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notif.timer, repeats: false)
            let request = UNNotificationRequest(identifier: notif.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Scheduling notification with id: \(notif.id)")
            }
    }
    
    func unscheduleNotifications(notif: Notification) -> Void {
        let notifs: [String] = [notif.id]
        print("Unscheduling notifications: \(notifs)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notifs)
    }
    
    func schedule(notif: Notification) -> Void {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission(notif: notif)
            case .authorized, .provisional:
                self.scheduleNotifications(notif: notif)
            default:
                break
            }
        }
    }
}
