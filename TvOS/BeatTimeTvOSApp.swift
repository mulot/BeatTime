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
            DrawingArcCircle(arcFrag: 999, lineWidth: 40)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                .mask(BeatTimeView(lineWidth: 40))
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
