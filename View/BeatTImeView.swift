//
//  ContentView.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

import SwiftUI

struct BeatTimeView: View {
    
    @State var beats: String = "0"
    @State private var viewID = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var lineWidth: CGFloat = 10
    var centiBeats: Bool = false
    var fullCircleBg: Bool = true
    var bgCircleColor: Color = Color.circleLine
    
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let displayLenght = min(frame.width, frame.height) - lineWidth
            let (startGradient, endGradient) = gradientPosition(frame: frame, lenght: displayLenght)
            ZStack {
                if (fullCircleBg) {
                    RingProgressView(arcFrag: 999, lineWidth: lineWidth)
                        .foregroundColor(bgCircleColor)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    //.background(Color.blue)
                }
                if (Double(beats) != nil) {
                    RingProgressView(arcFrag: Double(beats)!, lineWidth: lineWidth)
                        .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: startGradient, endPoint: endGradient)
                        .onAppear() {
                            withAnimation(.default.speed(0.30)) {
                                //print("animation on Appear")
                                self.beats = BeatTime().beats()
                            }
                        }
                    #if os(iOS)
                        .id(viewID)
                        .onTapGesture {
                                //print("animation on Tap")
                                self.beats = "0"
                                viewID += 1
                        }
                    #elseif os(tvOS)
                    #endif
                    /*
                        RingProgressView(arcFrag: Double(beats)!, lineWidth: lineWidth)
                            .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient], startPoint: startGradient, endPoint: endGradient)
                            .onAppear() {
                                withAnimation(.default) {
                                    //print("animation on Appear")
                                    self.beats = BeatTime().beats()
                                }
                            }
                    #endif*/
                }
                TextFitView(text: "@" + beats, size: displayLenght)
                    .gradientForeground(colors: [.startGradient, .midGradient, .mid2Gradient, .endGradient])
                /*Text("@" + beats)
                .font(.largeTitle.bold())
                .font(.system(size: fontSize, weight: .bold))*/
                /*
                Circle()
                    .scaleEffect(0.05, anchor: startGradient)
                    .foregroundColor(Color.blue)
                Circle()
                    .scaleEffect(0.05, anchor: endGradient)
                    .foregroundColor(Color.red)
                 */
            }.onReceive(timer) { _ in
                beats = BeatTime().beats(centiBeats: centiBeats)
            }
            /*
            .onTapGesture {
                print("lenght: \(displayLenght) Height: \(frame.height) ratio: \(displayLenght / frame.height) startGradient: \(startGradient) endGradient: \(endGradient)")
            }
             */
        }
        
    }
    
    func gradientPosition(date: Date = Date(), frame: CGRect, lenght: CGFloat) -> (UnitPoint, UnitPoint)
    {
        let nbHour = hoursOffsetWithGMT()
        let angle = (2 * Double.pi) / 24 * Double(nbHour)
        let r = lenght / 2
        let startCircle = UnitPoint(x: 0.5, y: (1 - (lenght / frame.height)) / 2)
        let endCircle = UnitPoint(x: 0.5, y: 1 - ((1 - (lenght / frame.height)) / 2))
        var startGradient = startCircle
        var endGradient = endCircle
        startGradient.x = startCircle.x + r*sin(angle)/frame.width
        startGradient.y = startCircle.y + (r*(1-cos(angle)))/frame.height
        endGradient.x =  startCircle.x + r*sin(angle+Double.pi)/frame.width
        endGradient.y = startCircle.y + (r*(1-cos(angle+Double.pi)))/frame.height
        //print("startCircle: \(startCircle) endCircle: \(endCircle) startGradient: \(startGradient) endGradient: \(endGradient) angle: \(angle) angle sin: \(sin(angle)) angle cos: \(cos(angle))")
        return (startGradient, endGradient)
    }
    
    
    func hoursOffsetWithGMT(date: Date = Date()) -> Int
    {
        //print(TimeZone.current.identifier)
        //print(TimeZone.abbreviationDictionary)
        //let seconds = TimeZone.init(identifier: "JST")!.secondsFromGMT(for: date)
        let seconds = TimeZone.current.secondsFromGMT(for: date)
        let hours = seconds / 3600
        //print("seconds: \(seconds) hours: \(-hours)")
        return(-hours)
    }
}

struct BeatTime_Previews: PreviewProvider {
    
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
            BeatTimeView(beats: "642", lineWidth: 25)
            //.background(Color.blue)
        }
        //}
    }
}
