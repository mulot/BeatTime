//
//  BeatTimeiOSApp.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

@main
struct BeatTimeiOSApp: App {
    //let fgColors: [Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .pink]
    //@State private var fgColor: Color = .gray
    //@State private var index = 1
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            /*
            BeatTimeView(lineWidth: 25)
                .background(Color.black)
                .foregroundColor(fgColor)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: {
                    //fgColor = fgColors.randomElement()!
                    fgColor = fgColors[index]
                    index += 1
                    if (index >= fgColors.count) {
                        index = 0
                    }
                })
            */
        }
    }
}

struct ContentView: View {
    
    var body: some View {
        ZStack {
            DrawingArcCircle(arcFrag: 999, lineWidth: 25)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                .mask(BeatTimeView(lineWidth: 25))
        }
    }
}



