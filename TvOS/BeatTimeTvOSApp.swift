//
//  BeatTimeTvOSApp.swift
//  BeatTimeTvOS
//
//  Created by Julien Mulot on 17/05/2021.
//

import SwiftUI

@main
struct BeatTimeTvOSApp: App {
    var body: some Scene {
        WindowGroup {
            /*
            BeatTimeView(lineWidth: 40)
                .foregroundColor(.orange)
                .font(.largeTitle)
 */
            ContentView()
            
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        ZStack {
            /*
            let beats: String = BeatTime().beats()
            
            DrawingArcCircle(arcFrag: 999, lineWidth: 40)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            DrawingArcCircle(arcFrag: Double(beats)!, lineWidth: 40)
                .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
            Text("@" + beats)
                .font(.title.bold())
                .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                */
            BeatTimeView(lineWidth: 40)

        }
    }
}

struct BeatTimeTvOSApp_Previews: PreviewProvider {
    static var previews: some View {
        /*
        BeatTimeView(lineWidth: 40)
            .foregroundColor(.orange)
            .font(.largeTitle)
 */
        ContentView()
    }
}
