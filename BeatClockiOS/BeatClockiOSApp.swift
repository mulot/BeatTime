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
            BeatClockView(lineWidth: 25)
                .background(Color.black)
                .foregroundColor(fgColor)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    fgColor = fgColors.randomElement()!
                })
        }
    }
}
