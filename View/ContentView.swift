//
//  ContentView.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        BeatTimeView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BeatTimeView: View {
    
    @State var beat: BeatTime = BeatTime()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    //var background = Color.black
    //var lineColor = Color.timeLine
    //var textColor = Color.timeLine
    var lineWidth: CGFloat = 10
    
    var body: some View {
        ZStack {
            if (Double(beat.beats()) != nil) {
                DrawingArcCircle(arcFrag: Double(beat.beats())!, lineWidth: lineWidth)
                    //.background(background)
            }
            Text("@" + beat.beats())
                    //.foregroundColor(textColor)
                    .font(.largeTitle).bold()
        }.onReceive(timer) { _ in
            beat = BeatTime()
        }
    }
}
