//
//  BeatClockiOSApp.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

@main
struct BeatClockiOSApp: App {
    
    let fgColors: [Color] = [.gray, .red, .orange, .yellow,
                               .green, .blue, .purple, .pink]
        @State private var fgColor: Color = .gray
    
    
    var body: some Scene {

        WindowGroup {
            //ContentView()
            BeatClockView(lineWidth: 15)
                //.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .foregroundColor(fgColor)
                .onTapGesture(perform: {
                    fgColor = fgColors.randomElement()!
                })
        }
    }
}
