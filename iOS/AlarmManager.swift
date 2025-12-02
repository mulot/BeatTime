//
//  AlarmManager.swift
//  BeatTime
//
//  Created by Julien Mulot on 28/11/2025.
//

import AlarmKit
import SwiftUI

struct BeatAlarmData: AlarmMetadata {
    var id: UUID
    var title: String
    var date: Date
    
    init(id: UUID, title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
}

class AlarmModel {
    typealias AlarmConfiguration = AlarmManager.AlarmConfiguration<BeatAlarmData>
    typealias AlarmsMap = [UUID: (Alarm, LocalizedStringResource)]
    
    var notifications = [Notification]()
    var alarmsMap = AlarmsMap()
    @ObservationIgnored private let alarmManager = AlarmManager.shared
    
    var hasUpcomingAlerts: Bool {
        !alarmsMap.isEmpty
    }
    
    init() {
        observeAlarms()
    }
    
    func fetchAlarms() {
        do {
            let remoteAlarms = try alarmManager.alarms
            updateAlarmState(with: remoteAlarms)
        } catch {
            print("Error fetching alarms: \(error)")
        }
    }
    
    // Schedules an alarm with message and date
    func scheduleFixAlarm(title: String, date: Date) {
        let localizedTitle: LocalizedStringResource = LocalizedStringResource(stringLiteral: title)
        let alertContent = AlarmPresentation.Alert(title: localizedTitle, stopButton: .stopButton, secondaryButton: .openAppButton, secondaryButtonBehavior: .custom)
        let attributes = AlarmAttributes<BeatAlarmData>(presentation: AlarmPresentation(alert: alertContent),
                                                        tintColor: Color.accentColor)
        let scheduleFixed = Alarm.Schedule.fixed(date)
        let alarmConfiguration = AlarmConfiguration(schedule: scheduleFixed, attributes: attributes)

        print("Date: \(date)")
        scheduleAlarm(id: UUID(), label: localizedTitle, alarmConfiguration: alarmConfiguration)
    }
    
    func scheduleFixAlarm(notif: Notification) {
        let localizedTitle: LocalizedStringResource = LocalizedStringResource(stringLiteral: notif.title)
        let alertContent = AlarmPresentation.Alert(title: localizedTitle, stopButton: .stopButton, secondaryButton: .openAppButton, secondaryButtonBehavior: .custom)
        let attributes = AlarmAttributes<BeatAlarmData>(presentation: AlarmPresentation(alert: alertContent),
                                                        tintColor: Color.accentColor)
        let scheduleFixed = Alarm.Schedule.fixed(notif.date)
        let alarmConfiguration = AlarmConfiguration(schedule: scheduleFixed, attributes: attributes)
        
        print("Date: \(notif.date)")
        notifications.append(notif)
        scheduleAlarm(id: notif.id, label: localizedTitle, alarmConfiguration: alarmConfiguration)
    }
    
//    func scheduleAlarm(id: UUID, label: LocalizedStringResource, alarmConfiguration: AlarmConfiguration) {
//        Task {
//            do {
//                guard await requestAuthorization() else {
//                    print("Not authorized to schedule alarms.")
//                    return
//                }
//                let alarm = try await alarmManager.schedule(id: id, configuration: alarmConfiguration)
//                await MainActor.run {
//                    alarmsMap[id] = (alarm, label)
//                }
//            } catch {
//                print("Error encountered when scheduling alarm: \(error)")
//            }
//        }
//    }
    
    func scheduleAlarm(id: UUID, label: LocalizedStringResource, alarmConfiguration: AlarmConfiguration) {
        Task {
            do {
                guard await requestAuthorization() else { return }
                let alarm = try await alarmManager.schedule(id: id, configuration: alarmConfiguration)
                await MainActor.run {
                    alarmsMap[id] = (alarm, label)
                    print("Alam added: \(label) with id: \(id)")
                }
            } catch {
                print("Error encountered when scheduling alarm: \(error)")
            }
        }
    }
    
    func removeNotification(notif: Notification) -> Void {
        if let index = notifications.firstIndex(of: notif) {
            //print("remove notif: \(notif.id)")
            self.unscheduleAlarm(with: notif.id)
            notifications.remove(at: index)
        }
    }
    
    func unscheduleAlarm(with alarmID: UUID) {
        //print("unschedule Alarm ID: \(alarmID) alarm: \(alarmsMap[alarmID], default: "Unknown alarm")")
        try? alarmManager.cancel(id: alarmID)
        Task { @MainActor in
            print("Task unschedule Alarm ID: \(alarmID) alarm: \(alarmsMap[alarmID], default: "Unknown alarm")")
            alarmsMap[alarmID] = nil
        }
    }
    
    private func observeAlarms() {
        Task {
            for await incomingAlarms in alarmManager.alarmUpdates {
                updateAlarmState(with: incomingAlarms)
            }
        }
    }
    
    private func updateAlarmState(with remoteAlarms: [Alarm]) {
        Task { @MainActor in
            
            // Update existing alarm states.
            remoteAlarms.forEach { updated in
                alarmsMap[updated.id, default: (updated, "Old Alarm)")].0 = updated
            }
            
            let knownAlarmIDs = Set(alarmsMap.keys)
            let incomingAlarmIDs = Set(remoteAlarms.map(\.id))
            
            // Clean-up removed alarms.
            let removedAlarmIDs = Set(knownAlarmIDs.subtracting(incomingAlarmIDs))
            removedAlarmIDs.forEach {
                alarmsMap[$0] = nil
            }
        }
    }
    
    private func requestAuthorization() async -> Bool {
        switch alarmManager.authorizationState {
        case .notDetermined:
            do {
                let state = try await alarmManager.requestAuthorization()
                return state == .authorized
            } catch {
                print("Error occurred while requesting authorization: \(error)")
                return false
            }
        case .denied: return false
        case .authorized: return true
        @unknown default: return false
        }
    }
}

extension AlarmButton {
    static var openAppButton: Self {
        AlarmButton(text: "Open", textColor: .black, systemImageName: "swift")
    }
    
    static var pauseButton: Self {
        AlarmButton(text: "Pause", textColor: .black, systemImageName: "pause.fill")
    }
    
    static var resumeButton: Self {
        AlarmButton(text: "Start", textColor: .black, systemImageName: "play.fill")
    }
    
    static var repeatButton: Self {
        AlarmButton(text: "Repeat", textColor: .black, systemImageName: "repeat.circle")
    }
    
    static var stopButton: Self {
        AlarmButton(text: "Dismiss", textColor: .white, systemImageName: "stop.circle")
    }
}
