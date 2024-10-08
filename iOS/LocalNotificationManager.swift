//
//  LocalNotificationManager.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 05/02/2024.
//

import Foundation
import UserNotifications
import SwiftData

@Model
class Notification: Identifiable, Hashable {
    var id: String
    var title: String
    var timer: TimeInterval
    var date: Date
    
    init(id: String, title: String, timer: TimeInterval, date: Date) {
        self.id = id
        self.title = title
        self.timer = timer
        self.date = date
    }
}

class LocalNotificationManager {
    var notifications = [Notification]()
    
    func requestPermission(notif: Notification) -> Void {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if granted == true && error == nil {
                    self.scheduleNotifications(notif: notif)
                    // We have permission!
                }
            }
    }
    
    func addNotification(notif: Notification) -> Void {
        //let notif = Notification(id: UUID().uuidString, title: title, timer: time, date: date)
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
            content.sound = UNNotificationSound.default
        //content.badge = 1
        //UNUserNotificationCenter.current().setBadgeCount(1)
            
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
