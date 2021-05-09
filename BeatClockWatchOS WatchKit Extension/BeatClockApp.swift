//
//  BeatClockApp.swift
//  BeatClockWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI

@main
struct BeatClockApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
                ContentView()
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
