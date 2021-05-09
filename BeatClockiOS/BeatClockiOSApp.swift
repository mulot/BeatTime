//
//  BeatClockiOSApp.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

@main
struct BeatClockiOSApp: App {
    
    var body: some Scene {
        let beat: BeatClock = BeatClock()
        
        WindowGroup {
            ContentView(beat: beat)
        }
    }
}
