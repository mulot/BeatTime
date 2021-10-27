//
//  ContentView.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct BeatTimeView: View {
    
    @State var beats: String = BeatTime().beats()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var lineWidth: CGFloat = 10
    var centiBeats: Bool = false
    var fontSize: CGFloat = 96
    
    var body: some View {
        GeometryReader { geometry in
        let frame = geometry.frame(in: .local)
        let lenght = min(frame.width, frame.height)
        ZStack {
            RingProgressView(arcFrag: 999, lineWidth: lineWidth)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                //.background(Color.blue)
            if (Double(beats) != nil) {
                RingProgressView(arcFrag: Double(beats)!, lineWidth: lineWidth)
                    .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
            }
            TextBeatsView(text: "@" + beats, size: lenght)
            //Text("@" + beats)
                //.font(.largeTitle.bold())
                //.font(.system(size: fontSize, weight: .bold))
                .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
        }.onReceive(timer) { _ in
            beats = BeatTime().beats(centiBeats: centiBeats)
        }
    }
    }
}

struct Gradient_Previews: PreviewProvider {
    
    static var previews: some View {
        //GeometryReader { geometry in
        //let frame = geometry.frame(in: .local)
        //let circleDiameter = min(frame.width, frame.height)
        ZStack {
            /*
            DrawingArcCircle(arcFrag: 999, lineWidth: 15)
                .foregroundColor(.circleLine)
                .shadow(radius: 10)
            LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                //.frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                .mask(BeatTimeView(beats: "642", lineWidth: 15))
            */
            BeatTimeView(beats: "642", lineWidth: 15)
        }
        //}
    }
}
