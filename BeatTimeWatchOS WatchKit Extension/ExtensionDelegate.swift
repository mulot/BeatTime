//
//  ExtensionDelegate.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 13/05/2021.
//

/*
 Abstract:
 A delegate object for the WatchKit extension that implements the needed life cycle methods.
 */

import WatchKit
import ClockKit
import os

// The app's extension delegate.
class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    let logger = Logger(subsystem: "mulot.org.BeatTimeWatchOS.watchkitapp.watchkitextension.ExtensionDelegate",
                        category: "Extension Delegate")
    
    // MARK: - Delegate Methods
    
    // Called when a background task occurs.
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        logger.debug("Handling a background task...")
        logger.debug("App State: \(WKExtension.shared().applicationState.rawValue)")
        for task in backgroundTasks {
            logger.debug("Task: \(task)")
            switch task {
            // Handle background refresh tasks.
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                //let beatime = BeatTime().beats()
                if let userInfo: NSDictionary = backgroundTask.userInfo as? NSDictionary {
                    if let then:Date = userInfo["submissionDate"] as? Date {
                        let interval = Date.init().timeIntervalSince(then)
                        logger.debug("interval since request was made \(interval)")
                    }
                }
                updateActiveComplications()
                scheduleBAR(first: false)
                logger.debug("Background Task Completed Successfully!")
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}

// Schedule the next background refresh task.
let scheduleLogger = Logger(subsystem: "mulot.org.BeatTimeWatchOS.watchkitapp.watchkitextension.scheduleLogger",
                            category: "Scheduler")

func scheduleBAR(first: Bool) {
    let now = Date()
    let scheduledDate = now.addingTimeInterval(first ? 60 : 60*60)
    let info:NSDictionary = ["submissionDate":now]
    let wkExt = WKExtension.shared()
    wkExt.scheduleBackgroundRefresh(withPreferredDate: scheduledDate, userInfo: info) { (error: Error?) in
        if (error != nil) {
            scheduleLogger.debug("background refresh could not be scheduled \(error.debugDescription)")
        }
    }
}

func updateActiveComplications() {
    let complicationServer = CLKComplicationServer.sharedInstance()
    if let activeComplications = complicationServer.activeComplications {
        for complication in activeComplications {
            complicationServer.reloadTimeline(for: complication)
        }
    }
}
