//
//  ContentView.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        DetailView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DetailView: View {
    
    @State var beat: BeatClock = BeatClock()
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
        }.onReceive(timer) { _ in
            beat = BeatClock()
        }
    }
}
