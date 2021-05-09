//
//  UIViewDraw.swift
//  BeatClockiOS
//
//  Created by Julien Mulot on 08/05/2021.
//

//import Foundation
import SwiftUI

struct DrawingArcCircle: View {
    
    var arcFrag: Double = 0
    var lineWidth: CGFloat = 10
    var linecolor: Color = Color.timeLine
     /*
    var lineColor: CGColor = Color.blue.cgColor!
    var startColor =  Color(red: 0, green: 30/255, blue: 50/255)
    var midColor = Color.purple
    var mid2Color = Color(red: 247/255, green: 186/255, blue: 0)
    var endColor = Color.yellow
    var isShadow: Bool = false
*/
    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            let arcLength: Double = ((arcFrag * 360)/1000 - 90)
            
            Path { path in
                path.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width/2 - (lineWidth)), startAngle: Angle.degrees(270), endAngle: Angle.degrees(arcLength), clockwise: false)
            }
            .stroke(linecolor, style: StrokeStyle(lineWidth: lineWidth, lineCap: CGLineCap.round))
        }
    }
}

struct UIViewDraw_Previews: PreviewProvider {
    static var previews: some View {
        DrawingArcCircle(arcFrag: Double(BeatClock().beatTime())!)
    }
}
