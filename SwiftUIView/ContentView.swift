//
//  ContentView.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        BeatClockView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BeatClockView: View {
    
    @State var beat: BeatClock = BeatClock()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //var background = Color.black
    //var lineColor = Color.timeLine
    //var textColor = Color.timeLine
    var lineWidth: CGFloat = 10
    
    var body: some View {
        ZStack {
            if (Double(beat.beatTime()) != nil) {
                DrawingArcCircle(arcFrag: Double(beat.beatTime())!, lineWidth: lineWidth)
                    //.background(background)
            }
                Text(beat.beatTime())
                    //.foregroundColor(textColor)
                    .font(.largeTitle).bold()
        }.onReceive(timer) { _ in
            beat = BeatClock()
        }
    }
}
