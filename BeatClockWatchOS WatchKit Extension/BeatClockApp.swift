//
//  BeatClockApp.swift
//  BeatClockWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI

@main
struct BeatClockApp: App {
    let fgColors: [Color] = [.orange, .white, .gray, .red, .yellow, .green, .blue, .purple, .pink]
    @State private var index = 0.0
    //@State private var fgColor = Color.gray
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            BeatClockView()
                .background(Color.black)
                .foregroundColor(fgColors[Int(index)])
                /*
                 .onTapGesture(perform: {
                 fgColor = fgColors[index]
                 index += 1
                 if (index >= fgColors.count) {
                 index = 0
                 }
                 })
                 */
                //Text("Index : \(index)")
                .focusable()
                .digitalCrownRotation($index, from: 0, through: Double((fgColors.count - 1)), by: 1, sensitivity: .low, isContinuous: true, isHapticFeedbackEnabled: true)
        }
        WKNotificationScene(controller: NotificationController.self, category: "mulot.org.BeatClock.time")
    }
}
