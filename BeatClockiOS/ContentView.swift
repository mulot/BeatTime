//
//  ContentView.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct ContentView: View {
    var beat: BeatClock
    
    var body: some View {
        DetailView(beat: beat)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(beat: BeatClock())
    }
}

struct DetailView: View {
    
    var beat: BeatClock = BeatClock()
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            if (Double(beat.beatTime()) != nil) {
                DrawingArcCircle(arcFrag: Double(beat.beatTime())!, linecolor: Color.green)
                    .background(Color.black)
                Text(beat.beatTime())
                    .foregroundColor(.green)
                    .font(.largeTitle).bold()
            }
        }
    }
}
