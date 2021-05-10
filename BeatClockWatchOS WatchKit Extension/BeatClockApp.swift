//
//  BeatClockApp.swift
//  BeatClockWatchOS WatchKit Extension
//
//  Created by Julien Mulot on 09/05/2021.
//

import SwiftUI

@main
struct BeatClockApp: App {
    let fgColors: [Color] = [.gray, .red, .orange, .yellow,
                             Color.timeLine, .blue, .purple, .pink]
    @State private var fgColor: Color = Color.timeLine
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
                //ContentView()
            BeatClockView()
                .background(Color.black)
                .foregroundColor(fgColor)
                .onTapGesture(perform: {
                    fgColor = fgColors.randomElement()!
                })
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
