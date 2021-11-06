//
//  UIViewDraw.swift
//  BeatTimeiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

//import Foundation
import SwiftUI

extension View {
    public func gradientForeground(colors: [Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: startPoint,
                                    endPoint: endPoint))
            .mask(self)
    }
}

struct RingProgressView: Shape {
    
    var arcFrag: Double = 0
    var lineWidth: CGFloat = 10
    /*
     var lineColor: Color = Color.timeLine
     var startColor =  Color(red: 0, green: 30/255, blue: 50/255)
     var midColor = Color.purple
     var mid2Color = Color(red: 247/255, green: 186/255, blue: 0)
     var endColor = Color.yellow
     var isShadow: Bool = false
     */
    
    func path(in rect: CGRect) -> Path {
            //let frame = geometry.frame(in: .local)
            let arcLength: Double = ((arcFrag * 360)/1000 - 90)
            let circleDiameter = min(rect.width, rect.height)
            
            var path = Path()
            path.addArc(center: CGPoint(x: rect.width/2, y: rect.height/2), radius: (circleDiameter/2 - (lineWidth)), startAngle: Angle.degrees(270), endAngle: Angle.degrees(arcLength), clockwise: false)
            //.animation(.easeInOut, value: arcLength)
            //.stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
        return path.strokedPath( StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
    }
    
    var animatableData: Double {
        get { arcFrag }
        set { arcFrag = newValue }
    }
}

struct TextFitView: View {
    
    var text: String
    var size: CGFloat
    
    var body: some View {
        let fontSize: CGFloat = size / CGFloat(text.count)
        Text(text)
            .font(.system(size: fontSize, weight: .bold))
    }
}

struct RingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        RingProgressView(arcFrag: Double(BeatTime().beats())!, lineWidth: 25)
            .foregroundColor(Color.orange)
        //.background(Color.blue)
    }
}

struct TextFitView_Previews: PreviewProvider {
    static var previews: some View {
        TextFitView(text: "@642", size: 200)
        //.background(Color.blue)
    }
}
