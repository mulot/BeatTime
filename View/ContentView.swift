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
        
        GeometryReader { geometry in
            //let frame = geometry.frame(in: .local)
            //let circleDiameter = min(frame.width, frame.height)
            LinearGradient(gradient: Gradient(colors: [Color(.sRGB, red: 0, green: 30/255, blue: 50/255, opacity: 1), .purple, Color(.sRGB, red: 247/255, green: 186/255, blue: 0, opacity: 1), Color(.sRGB, red: 1, green: 1, blue: 0, opacity: 1)]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                //.frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                .mask(BeatTimeView(lineWidth: 25))
            //BeatTimeView(lineWidth: 25)
        }
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
