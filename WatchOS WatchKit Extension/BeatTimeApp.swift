//
//  BeatTimeApp.swift
//  BeatTimeWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI
import os

@main
struct BeatTimeApp: App {
    @WKExtensionDelegateAdaptor private var appDelegate: ExtensionDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    let fgColors: [Color] = [.orange, .gray, .red, .yellow, .green, .blue, .purple, .pink]
    @State private var index = 0.0
    let logger = Logger(subsystem: "mulot.org.BeatTimeWatchOS.watchkitapp.watchkitextension.App", category: "App View")
    @State var beats: String = BeatTime().beats()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //@State private var fgColor = Color.gray
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ZStack {
                DrawingArcCircle(arcFrag: 999)
                    .foregroundColor(.circleLine)
                //BeatTimeView()
                DrawingArcCircle(arcFrag: Double(beats)!)
                    .foregroundColor(fgColors[Int(index)])
                Text("@" + beats)
                    .font(.title.bold())
                    .foregroundColor(fgColors[Int(index)])
                    //.background(Color.black)
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
            }.onReceive(timer) { _ in
                beats = BeatTime().beats()
            }
        }.onChange(of: scenePhase) { (phase) in
            switch phase {
            case .inactive:
                logger.debug("Scene became inactive.")
            case .active:
                logger.debug("Scene became active.")
            case .background:
                logger.debug("Scene moved to the background.")
                // Schedule a background refresh task
                // to update the complications.
                scheduleBAR(first: true)
            @unknown default:
                logger.debug("Scene entered unknown state.")
                assertionFailure()
            }
        }
        WKNotificationScene(controller: NotificationController.self, category: "mulot.org.BeatTime.time")
    }
}
