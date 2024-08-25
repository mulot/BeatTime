//
//  BeatTimeTvOSApp.swift
//  BeatTimeTvOS
//
//  Created by Julien Mulot on 17/05/2021.
//

import SwiftUI

//var hoursOffsetGMT = -4

@main
struct BeatTimeTvOSApp: App {
    @State var hoursOffsetGMT = BeatTime.hoursOffsetWithGMT()
    
    var body: some Scene {
        WindowGroup {
            //VStack (alignment: .trailing) {
            ZStack (alignment: .topTrailing) {
                GMTView(hoursOffsetGMT: $hoursOffsetGMT)
                //.background(.green)
                ContentView(hoursOffsetGMT: $hoursOffsetGMT)
                //.background(.orange)
            }
        }
    }
}

struct GMTView: View {
    
    @Binding var hoursOffsetGMT: Int
    
    var body: some View {
        HStack {
            if hoursOffsetGMT > 0 {
                Text("GMT: +\(hoursOffsetGMT)")
                    .gradientLinear(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: .leading, endPoint: .trailing)
                    .font(.headline)
            }
            else {
                Text("GMT: \(hoursOffsetGMT)")
                    .gradientLinear(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: .leading, endPoint: .trailing)
                    .font(.headline)
            }
        }
    }
}

struct ContentView: View {
    
    @Binding var hoursOffsetGMT: Int
    @State var bgCircle: Bool = true
    @State var centiBeats: Bool = false
    @State var lineWidth: CGFloat = 40
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1.0)
            .onEnded { _ in
                hoursOffsetGMT = BeatTime.hoursOffsetWithGMT()
                //print("longpress > GMT: \(hoursOffsetGMT)")
            }
    }
    
    var body: some View {
        ZStack {
            /*
            let beats: String = BeatTime().beats()
            
            DrawingArcCircle(arcFrag: 999, lineWidth: 40)
                .foregroundColor(.circleLine)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            DrawingArcCircle(arcFrag: Double(beats)!, lineWidth: 40)
                .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
            Text("@" + beats)
                .font(.title.bold())
                .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                */
            if #available(tvOS 16.0, *) {
                BeatTimeView(lineWidth: lineWidth, centiBeats: centiBeats, fullCircleBg: bgCircle, hoursOffsetGMT: hoursOffsetGMT)
                    .focusable(true)
                    .highPriorityGesture(longPress)
                    .onLongPressGesture(minimumDuration: 0.01, pressing: { _ in }) {
                        print("short press")
                        centiBeats = !centiBeats
                    }
                    .onMoveCommand(perform: { direction in
                        switch direction {
                        case .down:
                            print("down press")
                            bgCircle = !bgCircle
                        case .up:
                            print("up press")
                            lineWidth += 10
                            if lineWidth == 110 {
                                lineWidth = 40
                            }
                        case .left:
                            print("left press")
                            hoursOffsetGMT -= 1
                            if hoursOffsetGMT == -13 {
                                hoursOffsetGMT = 12
                            }
                        case .right:
                            print("right press")
                            hoursOffsetGMT += 1
                            if hoursOffsetGMT == 13 {
                                hoursOffsetGMT = -12
                            }
                        default:
                            print("move press")
                        }
                    })
            }
            else {
                BeatTimeView(lineWidth: lineWidth)
            }
        }
    }
}

struct BeatTimeTvOSApp_Previews: PreviewProvider {
    var hoursOffsetGMT = BeatTime.hoursOffsetWithGMT()
    
    static var previews: some View {
        /*
        BeatTimeView(lineWidth: 40)
            .foregroundColor(.orange)
            .font(.largeTitle)
 */
        ZStack {
                BeatTimeView(lineWidth: 40)
        }
    }
}
