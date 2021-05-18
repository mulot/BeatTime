//
//  ContentView.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

/*
struct ContentView: View {
    
    var body: some View {
        BeatTimeView()
    }
}
 */

struct Gradient_Previews: PreviewProvider {
    
    static var previews: some View {
        
        //GeometryReader { geometry in
            //let frame = geometry.frame(in: .local)
            //let circleDiameter = min(frame.width, frame.height)
        ZStack {
            DrawingArcCircle(arcFrag: 999, lineWidth: 25)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            LinearGradient(gradient: Gradient(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient]), startPoint: UnitPoint(x: 0.5, y: 0.25), endPoint: UnitPoint(x: 0.5, y: 0.75))
                //.frame(width: circleDiameter, height: circleDiameter, alignment: .center)
                .mask(BeatTimeView(lineWidth: 25))
        }
        //}
        //BeatTimeView(lineWidth: 25)
    }
}

struct BeatTimeView: View {
    
    @State var beats: String = BeatTime().beats()
    #if os(iOS) || os(watchOS) || os(tvOS)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    #endif
    var lineWidth: CGFloat = 10
    
    var body: some View {
        #if os(iOS) || os(watchOS) || os(tvOS)
        ZStack {
            if (Double(beats) != nil) {
                DrawingArcCircle(arcFrag: Double(beats)!, lineWidth: lineWidth)
                //.background(.black)
            }
            Text("@\(beats)")
                //.foregroundColor(.green)
                .font(.largeTitle).bold()
        }.onReceive(timer) { _ in
            beats = BeatTime().beats()
        }
        #else
        ZStack {
            if (Double(beats) != nil) {
                DrawingArcCircle(arcFrag: Double(beats)!, lineWidth: lineWidth)
                //.background(background)
            }
        }
        #endif
    }
}
